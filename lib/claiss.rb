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
          puts "#{spec.summary}"
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
          source = File.expand_path(origin_path + "/**/*", __FILE__)
          Dir.glob(source).reject{ |f| File.directory?(f)}.each do |file_name|
            destination = file_name
            text = File.read(file_name) if !File.directory?(file_name)

            dict.map do |p, i|
              destination.gsub!(p, i)
              if !text.nil?
                text.gsub!(p, i)
              end
            end

            FileUtils.mkdir_p(File.dirname(destination))
            File.write(destination, text) if !File.directory?(file_name)
            puts "File: #{destination}, OK" if !File.directory?(file_name)
          end
          puts "done!"

        end
      end

      register "version", Version, aliases: ["v", "-v", "--version"]
      register "refactor",Refactor
  end
