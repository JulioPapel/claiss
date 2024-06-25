module CLAISS
    module Commands
      extend Dry::CLI::Registry
  
      register "version", Version, aliases: ["v", "-v", "--version"]
      register "refactor", Refactor
      register "fix_ruby_permissions", FixRubyPermissions
    end
  end