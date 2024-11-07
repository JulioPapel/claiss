require "dry/cli"
require "bundler/setup"
require 'pathname'
require 'json'
require "fileutils"
require 'logger'
require 'parallel'
require 'ruby-progressbar'

# CLAISS module provides CLI commands for refactoring and managing Ruby projects
module CLAISS
  IGNORED_DIRECTORIES = [".git/", "node_modules/"]
  DEFAULT_JSON_DIR = File.join(Dir.home, '.claiss')

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
      "path/to/project autokeras --destination path/to/output"
    ]
  
    def call(path:, rules:, destination: nil, **)
      origin_path = File.expand_path(path)
      destination_path = destination ? File.expand_path(destination) : nil
      
      json_file = File.join(DEFAULT_JSON_DIR, "#{rules}.json")
      dict = load_dictionary(json_file)
  
      files = get_files_to_process(origin_path)
      process_files_in_parallel(files, dict, origin_path, destination_path)
      remove_empty_directories(destination_path || origin_path)
  
      puts "Done! Files have been refactored#{destination_path ? ' to the destination' : ' in place'}."
    end

    private

    def get_files_to_process(origin_path)
      Dir.glob(File.join(origin_path, '**', '*'), File::FNM_DOTMATCH).reject do |file_name|
        File.directory?(file_name) || IGNORED_DIRECTORIES.any? { |dir| file_name.include?(dir) }
      end
    end

    def process_files_in_parallel(files, dict, origin_path, destination_path)
      progress_bar = ProgressBar.create(
        total: files.size,
        format: "%a %b\u{15E7}%i %p%% %t",
        progress_mark: ' ',
        remainder_mark: "\u{FF65}"
      )
  
      Parallel.each(files, in_threads: Parallel.processor_count) do |file_name|
        refactor_file(file_name, dict, origin_path, destination_path)
        progress_bar.increment
      end
    end

    def load_dictionary(json_file)
      LOGGER.info("Attempting to load dictionary from: #{json_file}")
      
      unless File.exist?(json_file)
        error_message = "JSON file not found: #{json_file}"
        LOGGER.error(error_message)
        raise Errno::ENOENT, error_message
      end
    
      begin
        file_content = File.read(json_file)
        LOGGER.debug("File content: #{file_content}")
        
        parsed_content = JSON.parse(file_content)
        LOGGER.info("Successfully parsed JSON file")
        
        if parsed_content.empty?
          LOGGER.warn("The loaded dictionary is empty")
        else
          LOGGER.info("Loaded dictionary with #{parsed_content.size} key-value pairs")
        end
        
        parsed_content
      rescue JSON::ParserError => e
        error_message = "Error parsing JSON file '#{json_file}': #{e.message}"
        LOGGER.error(error_message)
        LOGGER.debug("JSON content that failed to parse: #{file_content}")
        raise JSON::ParserError, error_message
      rescue StandardError => e
        error_message = "Unexpected error while loading dictionary from '#{json_file}': #{e.message}"
        LOGGER.error(error_message)
        LOGGER.debug(e.backtrace.join("\n"))
        raise
      end
    end

    def process_files(origin_path, dict, destination_path)
      Dir.glob(File.join(origin_path, '**', '*'), File::FNM_DOTMATCH) do |file_name|
        next if File.directory?(file_name)
        next if IGNORED_DIRECTORIES.any? { |dir| file_name.include?(dir) }
        refactor_file(file_name, dict, origin_path, destination_path)
      end
    end

    def refactor_file(file_name, dict, origin_path, destination_path)
      begin
        # First, try to read the file as UTF-8
        text = File.read(file_name, encoding: 'UTF-8')
      rescue Encoding::InvalidByteSequenceError
        # If UTF-8 reading fails, fall back to binary reading and force UTF-8 encoding
        # This approach helps handle files with mixed or unknown encodings
        truncated_file_name = File.basename(file_name)
        LOGGER.warn("Invalid UTF-8 byte sequence in ...#{truncated_file_name}. Falling back to binary reading.")
        text = File.read(file_name, encoding: 'BINARY')
        text.force_encoding('UTF-8')
        # Replace any invalid or undefined characters with empty string
        text.encode!('UTF-8', invalid: :replace, undef: :replace, replace: '')
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
          LOGGER.info("File #{destination_path ? 'copied' : 'renamed'} from #{truncated_old} to #{truncated_new}")
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

    def remove_empty_directories(path)
      Dir.glob(File.join(path, '**', '*'), File::FNM_DOTMATCH).reverse_each do |dir_name|
        next unless File.directory?(dir_name)
        next if IGNORED_DIRECTORIES.any? { |ignored_dir| dir_name.include?(ignored_dir) }
        if (Dir.entries(dir_name) - %w[. ..]).empty?
          Dir.rmdir(dir_name)
          puts "Removed empty directory: #{dir_name}"
        end
      end
    end
  end

  class GenerateJson < Dry::CLI::Command
    desc "Generate a new JSON file with an empty key-value pair"
  
    option :output, type: :string, default: "rules", desc: "Name of the output JSON file (default: rules)"
    option :path, type: :string, desc: "Path to save the JSON file (default: ~/.claiss/)"
  
    example [
      "",
      "--output my_custom_rules",
      "--path /custom/path/ --output my_rules"
    ]
  
    def call(path:, rules:, destination: nil, **)
      origin_path = File.expand_path(path)
      destination_path = destination ? File.expand_path(destination) : nil
      
      json_file = File.join(DEFAULT_JSON_DIR, "#{rules}.json")
      
      begin
        dict = load_dictionary(json_file)
      rescue Errno::ENOENT => e
        puts e.message
        puts "Please make sure the JSON file exists in the ~/.claiss directory."
        exit(1)
      rescue JSON::ParserError => e
        puts e.message
        puts "Please check the JSON file for syntax errors."
        exit(1)
      rescue StandardError => e
        puts "An unexpected error occurred: #{e.message}"
        puts "Please check the log for more details."
        exit(1)
      end
    
      process_files(origin_path, dict, destination_path)
      remove_empty_directories(destination_path || origin_path)
    
      puts "Done! Files have been refactored#{destination_path ? ' to the destination' : ' in place'}."
    end

    private

    def ensure_json_extension(filename)
      return filename if filename.end_with?('.json')
      "#{filename}.json"
    end
  end

  class FixRubyPermissions < Dry::CLI::Command
    desc "Fix permissions for a Ruby project"

    argument :path, type: :string, required: false, default: ".", desc: "Path to the Ruby project (default: current directory)"

    example [
      "",
      "path/to/ruby/project"
    ]

    def call(path: ".", **)
      path = File.expand_path(path)

      Dir.glob(File.join(path, '**', '*'), File::FNM_DOTMATCH) do |item|
        next if item == '.' || item == '..'
        next if item.include?("node_modules/") # Ignore node_modules folder
        if File.directory?(item)
          File.chmod(0755, item)
        else
          fix_file_permissions(item)
        end
      end

      executable_files = ['bundle', 'rails', 'rake', 'spring']
      executable_files.each do |file|
        file_path = File.join(path, 'bin', file)
        if File.exist?(file_path)
          File.chmod(0755, file_path)
          puts "Made #{file_path} executable"
        end
      end

      puts "Permissions fixed for Ruby project at #{path}"
    end

    private

    def fix_file_permissions(file)
      if File.extname(file) == '.rb' || file.include?('/bin/')
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