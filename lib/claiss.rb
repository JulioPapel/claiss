require "bundler/setup"
require "dry/cli"
require "fileutils"
require "json"

module CLAISS
  class Error < StandardError; end

  class Version < Dry::CLI::Command
    desc "Print version"

    def call(*)
      puts "CLAISS version #{CLAISS::VERSION}"
    end
  end

  class Refactor < Dry::CLI::Command
    desc "Refactors terms and files on directories"
    argument :path, type: :string, required: true, desc: "Relative path directory"
    argument :json_file, type: :string, desc: "Provide a JSON file with replacement rules"

    def call(path:, json_file: nil, **)
      dict = load_dictionary(json_file)
      origin_path = File.expand_path(path)

      process_files(origin_path, dict)
      remove_empty_directories(origin_path)

      puts "Done! Files have been refactored in place."
    end

    private

    def load_dictionary(json_file)
      if json_file
        # Procura o arquivo no diretório atual e no ~/.claiss
        possible_paths = [
          json_file,
          File.expand_path(json_file),
          File.expand_path("~/.claiss/#{json_file}"),
        ]

        found_file = possible_paths.find { |path| File.exist?(path) }

        if found_file
          begin
            dict = JSON.parse(File.read(found_file))
            puts "Oba! Encontrei o arquivo em: #{found_file}"
            return dict
          rescue JSON::ParserError => e
            puts "Ops! O arquivo JSON não está no formato correto. Erro: #{e.message}"
          end
        else
          puts "Hmm, não consegui encontrar o arquivo. Procurei nesses lugares:"
          possible_paths.each { |path| puts "  - #{path}" }
        end

        puts "Vamos usar o dicionário interativo em vez disso, tá bom?"
        interactive_dictionary
      else
        interactive_dictionary
      end
    end

    def interactive_dictionary
      dict = {}
      loop do
        print "Term to search (or press Enter to finish): "
        search = STDIN.gets.chomp
        break if search.empty?
        print "Term to replace: "
        replace = STDIN.gets.chomp
        dict[search] = replace
      end
      dict
    end

    def process_files(origin_path, dict)
      Dir.glob(File.join(origin_path, "**", "*"), File::FNM_DOTMATCH).each do |file_name|
        next if File.directory?(file_name)
        next if file_name.include?(".git/") || file_name.include?("node_modules/") # Ignore .git and node_modules folders
        process_file(file_name, dict)
      end
    end

    def process_file(file_name, dict)
      text = File.read(file_name)

      dict.each do |search, replace|
        text.gsub!(search, replace)
      end

      new_file_name = file_name.dup

      dict.each do |search, replace|
        new_file_name.gsub!(search, replace)
      end

      # Create the directory for the new file if it doesn't exist
      new_dir = File.dirname(new_file_name)
      FileUtils.mkdir_p(new_dir) unless File.directory?(new_dir)

      # Write the changes to the new file name
      File.write(new_file_name, text)

      # If the filename has changed, delete the original file
      unless new_file_name == file_name
        File.delete(file_name) # Delete the original file
        puts "File renamed from #{file_name} to #{new_file_name}, OK"
      else
        puts "File: #{file_name}, OK"
      end
    end

    def remove_empty_directories(origin_path)
      Dir.glob(File.join(origin_path, "**", "*"), File::FNM_DOTMATCH).reverse_each do |dir_name|
        next unless File.directory?(dir_name)
        next if dir_name.include?(".git/") || dir_name.include?("node_modules/") # Ignorar pastas .git e node_modules
        next if dir_name == "." || dir_name == ".." # Ignorar diretórios especiais . e ..
        if (Dir.entries(dir_name) - %w[. ..]).empty?
          begin
            Dir.rmdir(dir_name)
            puts "Diretório vazio removido: #{dir_name}"
          rescue Errno::ENOTEMPTY, Errno::EINVAL => e
            puts "Não foi possível remover o diretório: #{dir_name}. Erro: #{e.message}"
          end
        end
      end
    end
  end

  class FixRubyPermissions < Dry::CLI::Command
    desc "Fix permissions for a Ruby project"
    argument :path, required: true, desc: "The path of your Ruby project"

    def call(path: nil, **)
      path ||= Dir.getwd
      path = File.expand_path(path)

      Dir.glob(File.join(path, "**", "*"), File::FNM_DOTMATCH) do |item|
        next if item == "." || item == ".."
        next if item.include?("node_modules/") # Ignore node_modules folder
        if File.directory?(item)
          File.chmod(0755, item)
        else
          fix_file_permissions(item)
        end
      end

      executable_files = ["bundle", "rails", "rake", "spring"]
      executable_files.each do |file|
        file_path = File.join(path, "bin", file)
        File.chmod(0755, file_path) if File.exist?(file_path)
      end

      puts "Permissions fixed for #{path}"
    end

    private

    def fix_file_permissions(file)
      current_permissions = File.stat(file).mode

      if current_permissions & 0o100 != 0 # Check if the owner has execute permission
        File.chmod(0755, file) # Maintain execution permission for owner, group, and others
      elsif current_permissions & 0o010 != 0 # Check if the group has execute permission
        File.chmod(0755, file) # Maintain execution permission for group and others
      elsif current_permissions & 0o001 != 0 # Check if others have execute permission
        File.chmod(0755, file) # Maintain execution permission for others
      else
        File.chmod(0644, file) # Otherwise, apply standard read/write permissions
      end
    end
  end
end

require_relative "claiss/version"
require_relative "claiss/commands"
require_relative "claiss/cli"
