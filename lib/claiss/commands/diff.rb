require "diffy"
require "fileutils"
require "tmpdir"

module CLAISS
  module Commands
    class Diff < Dry::CLI::Command
      desc "Show differences between original and refactored files"

      argument :path, type: :string, required: true, 
                    desc: "Path to the directory to analyze"
      argument :rules, type: :string, required: true, 
                      desc: "Name of the rules file (without .json extension)"
      option :context, type: :numeric, default: 3, 
                      desc: "Number of context lines to show around changes"
      option :color, type: :string, default: "auto", 
                    values: %w[auto on off], 
                    desc: "Colorize output (auto, on, off)"

      def call(path:, rules:, **options)
        origin_path = File.expand_path(path)
        json_file = File.join(Dir.home, ".claiss", "#{rules}.json")
        
        unless File.exist?(json_file)
          puts "Erro: Arquivo de regras não encontrado em #{json_file}"
          exit 1
        end

        # Cria um diretório temporário para a cópia
        temp_dir = Dir.mktmpdir("claiss-diff-")
        begin
          # Copia os arquivos originais para o diretório temporário
          FileUtils.cp_r("#{origin_path}/.", temp_dir)
          
          puts "\n=== ANALISANDO ALTERAÇÕES ===\n"
          puts "Diretório original: #{origin_path}"
          puts "Diretório temporário: #{temp_dir}"
          puts "Arquivo de regras: #{json_file}"
          puts ""
          
          # Aplica as alterações no diretório temporário
          refactor_command = CLAISS::Refactor.new
          refactor_command.call(path: temp_dir, rules: rules)
          
          # Mostra as diferenças
          show_differences(origin_path, temp_dir, options)
          
        ensure
          # Remove o diretório temporário
          FileUtils.remove_entry(temp_dir) if File.directory?(temp_dir)
        end
      end
      
      private
      
      def show_differences(origin_path, temp_dir, options)
        puts "\n=== ALTERAÇÕES DETECTADAS ===\n"
        
        # Configura o Diffy
        Diffy::Diff.default_format = :color
        Diffy::Diff.default_options[:context] = options[:context]
        
        # Para cada arquivo no diretório de origem
        Dir.glob(File.join(origin_path, "**", "*")) do |file|
          next unless File.file?(file)
          
          relative_path = file.sub(%r{^#{Regexp.escape(origin_path)}/?}, '')
          temp_file = File.join(temp_dir, relative_path)
          
          # Verifica se o arquivo foi modificado
          if File.exist?(temp_file) && !FileUtils.identical?(file, temp_file)
            puts "\n\e[1mArquivo: #{relative_path}\e[0m"
            
            # Mostra as diferenças
            diff = Diffy::Diff.new(file, temp_file, 
                                 source: 'files',
                                 include_diff_info: true)
            
            if diff.to_s.empty?
              puts "  Nenhuma diferença de conteúdo (pode ter mudado permissões ou metadados)"
            else
              # Formata a saída para melhor legibilidade
              diff_str = diff.to_s.gsub(/^\+(?![+\s])/, "\e[32m\\0\e[0m")  # Verde para adições
                             .gsub(/^-(?!--)/, "\e[31m\\0\e[0m")         # Vermelho para remoções
              puts diff_str
            end
          end
        end
        
        puts "\n=== ANÁLISE CONCLUÍDA ===\n"
      end
    end
  end
end
