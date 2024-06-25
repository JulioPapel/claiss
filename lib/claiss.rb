require "bundler/setup"
require "dry/cli"
require "fileutils"
require 'json'

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
      destination_path = File.expand_path("./refactored-#{Time.now.to_i}")

      dict[origin_path] = destination_path
      process_files(origin_path, dict)

      puts "Done! Your project is in the #{destination_path} folder"
    end

    private

    def load_dictionary(json_file)
      if json_file
        JSON.parse(File.read(json_file))
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
        process_file(file_name, dict)
      end
    end

    def process_file(file_name, dict)
      destination = file_name.gsub(dict.keys.first, dict.values.first)
      text = File.read(file_name)

      dict.each do |search, replace|
        destination.gsub!(search, replace)
        text.gsub!(search, replace)
      end

      FileUtils.mkdir_p(File.dirname(destination))
      File.write(destination, text)
      puts "File: #{destination}, OK"
    end
  end

  class FixRubyPermissions < Dry::CLI::Command
    desc "Fix permissions for a Ruby project"
    argument :path, required: true, desc: "The path of your Ruby project"

    def call(path: nil, **)
      path ||= Dir.getwd
      path = File.expand_path(path)

      Dir.glob(File.join(path, '**', '*'), File::FNM_DOTMATCH) do |item|
        next if item == '.' || item == '..'
        if File.directory?(item)
          File.chmod(0755, item)
        else
          File.chmod(0644, item)
        end
      end

      executable_files = ['bundle', 'rails', 'rake', 'spring']
      executable_files.each do |file|
        file_path = File.join(path, 'bin', file)
        File.chmod(0755, file_path) if File.exist?(file_path)
      end

      puts "Permissions fixed for #{path}"
    end
  end
end

require_relative "claiss/version"
require_relative "claiss/commands"
require_relative "claiss/cli"