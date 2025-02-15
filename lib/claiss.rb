require "dry/cli"
require "fileutils"
require "json"

# CLAISS module provides CLI commands for refactoring and managing Ruby projects
module CLAISS
  IGNORED_DIRECTORIES = [".git/", "node_modules/"]
  DEFAULT_JSON_DIR = File.join(Dir.home, ".claiss")

  # Initialize logger
  LOGGER = Logger.new(STDOUT)
  LOGGER.level = Logger::INFO  # Set to Logger::DEBUG for more verbose output

  class Error < StandardError; end

  class Version < Dry::CLI::Command
    desc "Print version"

    def call(*)
      puts "CLAISS version #{CLAISS::VERSION}"
    end
  end

  class Refactor < Dry::CLI::Command
    desc "Refactor files and filenames"

    argument :path, type: :string, required: true, desc: "Path to the directory to refactor"
    argument :rules, type: :string, required: true, desc: "Name of the rules file (without .json extension)"
    option :destination, type: :string, desc: "Destination path for refactored files"

    example [
      "path/to/project autokeras",
      "path/to/project autokeras --destination path/to/output",
    ]

    def call(path:, rules:, destination: nil, **)
      origin_path = File.expand_path(path)
      destination_path = destination ? File.expand_path(destination) : nil

      json_file = File.join(DEFAULT_JSON_DIR, "#{rules}.json")
      dict = load_dictionary(json_file)

      files = get_files_to_process(origin_path)
      process_files_in_parallel(files, dict, origin_path, destination_path)
      remove_empty_directories(destination_path || origin_path)

      puts "Done! Files have been refactored#{destination_path ? " to the destination" : " in place"}."
    end

    private

    def get_files_to_process(origin_path)
      Dir.glob(File.join(origin_path, "**", "*"), File::FNM_DOTMATCH).reject do |file_name|
        File.directory?(file_name) || IGNORED_DIRECTORIES.any? { |dir| file_name.include?(dir) }
      end
    end

    def process_files_in_parallel(files, dict, origin_path, destination_path)
      progress_bar = ProgressBar.create(
        total: files.size,
        format: "%a %b\u{15E7}%i %p%% %t",
        progress_mark: " ",
        remainder_mark: "\u{FF65}",
      )

      Parallel.each(files, in_threads: Parallel.processor_count) do |file_name|
        refactor_file(file_name, dict, origin_path, destination_path)
        progress_bar.increment
      end
    end

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

    def process_files(origin_path, dict, destination_path)
      Dir.glob(File.join(origin_path, "**", "*"), File::FNM_DOTMATCH) do |file_name|
        next if File.directory?(file_name)
        next if IGNORED_DIRECTORIES.any? { |dir| file_name.include?(dir) }
        refactor_file(file_name, dict, origin_path, destination_path)
      end
    end

    def refactor_file(file_name, dict, origin_path, destination_path)
      begin
        # First, try to read the file as UTF-8
        text = File.read(file_name, encoding: "UTF-8")
      rescue Encoding::InvalidByteSequenceError
        # If UTF-8 reading fails, fall back to binary reading and force UTF-8 encoding
        # This approach helps handle files with mixed or unknown encodings
        truncated_file_name = File.basename(file_name)
        LOGGER.warn("Invalid UTF-8 byte sequence in ...#{truncated_file_name}. Falling back to binary reading.")
        text = File.read(file_name, encoding: "BINARY")
        text.force_encoding("UTF-8")
        # Replace any invalid or undefined characters with empty string
        text.encode!("UTF-8", invalid: :replace, undef: :replace, replace: "")
      end

      text_changed = false
      dict.each do |search, replace|
        if text.gsub!(/#{Regexp.escape(search)}/, replace)
          text_changed = true
        end
      end

      relative_path = Pathname.new(file_name).relative_path_from(Pathname.new(origin_path))
      new_relative_path = replace_in_path(relative_path.to_s, dict)

      if destination_path
        new_file_name = File.join(destination_path, new_relative_path)
      else
        new_file_name = File.join(origin_path, new_relative_path)
      end

      new_dir = File.dirname(new_file_name)
      FileUtils.mkdir_p(new_dir) unless File.directory?(new_dir)

      if text_changed || new_file_name != file_name
        File.write(new_file_name, text)
        if destination_path || new_file_name != file_name
          truncated_old = "...#{File.basename(file_name)}"
          truncated_new = "...#{File.basename(new_file_name)}"
          LOGGER.info("File #{destination_path ? "copied" : "renamed"} from #{truncated_old} to #{truncated_new}")
        else
          truncated_file = "...#{File.basename(file_name)}"
          LOGGER.info("File contents updated: #{truncated_file}")
        end
        File.delete(file_name) if !destination_path && new_file_name != file_name
      end
    rescue => e
      truncated_file = "...#{File.basename(file_name)}"
      LOGGER.error("Error processing file #{truncated_file}: #{e.message}")
      LOGGER.debug(e.backtrace.join("\n"))
    end

    def replace_in_path(path, dict)
      dict.reduce(path) do |s, (search, replace)|
        s.gsub(/#{Regexp.escape(search)}/, replace)
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

    argument :path, type: :string, required: false, default: ".", desc: "Path to the Ruby project (default: current directory)"

    example [
      "",
      "path/to/ruby/project",
    ]

    def call(path: ".", **)
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

      puts "Permissions fixed for Ruby project at #{path}"
    end

    private

    def fix_file_permissions(file)
      if File.extname(file) == ".rb" || file.include?("/bin/")
        File.chmod(0755, file)
      else
        File.chmod(0644, file)
      end
    end
  end
end

require_relative "claiss/version"
require_relative "claiss/commands"
require_relative "claiss/cli"
