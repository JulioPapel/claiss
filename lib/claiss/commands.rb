module CLAISS
  module Commands
    extend Dry::CLI::Registry

    register "version", CLAISS::Version, aliases: ["v", "-v", "--version"]
    register "refactor", CLAISS::Refactor
    register "fix_ruby_permissions", CLAISS::FixRubyPermissions
    register "generate_json", CLAISS::GenerateJson
  end
end