require "bundler/setup"
require "dry/cli"
require "fileutils"
require "pathname"
require 'find'
require 'json'

module Claiss
  extend Dry::CLI::Registry

  class Version < Dry::CLI::Command
    desc "Print version"

    def call(*)
      spec = Gem::Specification::load("claiss.gemspec")
      puts "#{spec.description}"
      puts "Version: #{spec.version}"
    end
  end

  class Refactor < Dry::CLI::Command
    desc "Refactors terms and files on directories"
    argument :path, type: :string,  required: true, desc: "Relative path directory"
    argument :json_file, type: :string, desc: "Provide a Ruby hash file"
    
    def call(path:, json_file: nil, **)
      dict = {}
      search = ""
      replace = ""
      input = "y"
      temp_dir = "/refactored-#{Time.now.to_i.to_s}"
      origin_path = File.expand_path(path)
      destination_path = File.expand_path("."+ temp_dir)

      if !json_file.nil?
        jfile = File.read(json_file)
        dict = JSON.parse(jfile)
      else
        while input.downcase == "y" do 
          puts "Term to search: "
          search = STDIN.gets.chomp
          puts "Term to replace: "
          replace = STDIN.gets.chomp

          dict[search] = replace
          puts "\nAdd another? Type Y \nto Start Refactoring press Enter"
          input = STDIN.gets.chomp!
        end
      end

      dict = {origin_path => destination_path}.merge(dict)
      dict[origin_path] = destination_path
      source = File.join(origin_path, "**", "{*,.*}")
      Dir.glob(source, File::FNM_DOTMATCH).each do |file_name|
        next if File.directory?(file_name)

        destination = file_name
        text = File.read(file_name)

        dict.each do |p, i|
          destination.gsub!(p, i)
          text.gsub!(p, i)
        end

        FileUtils.mkdir_p(File.dirname(destination))
        File.write(destination, text)
        puts "File: #{destination}, OK"
      end

      puts "done! your project is in the #{temp_dir} folder"
    end
  end

  class FixRubyPermissions < Dry::CLI::Command
    argument :path, required: true, desc: "The path of your ruby project"
    
    def call(path: nil, **)
      if path.nil?
        path = File.basename(Dir.getwd)
      end
      
      # Run shell scripts to set permissions.
      directories = `chmod 755 $(find #{path} -type d)`
      files = `chmod 644 $(find #{path} -type f)`
      bundle = `chmod 755 #{path+'/bin/bundle'}`
      rails = `chmod 755 #{path+'/bin/rails'}`
      rake = `chmod 755 #{path+'/bin/rake'}`
      spring = `chmod 755 #{path+'/bin/spring'}`
    end
  end

  register "version", Version, aliases: ["v", "-v", "--version"]
  register "refactor", Refactor
  register "fix_ruby_permissions", FixRubyPermissions
end
