require_relative 'commands/diff'

module CLAISS
  module Commands
    extend Dry::CLI::Registry

    register "version", Version, aliases: ["v", "-v", "--version"]
    register "refactor", Refactor
    register "fix_ruby_permissions", FixRubyPermissions
    register "diff", Diff, aliases: ["d", "--diff"]
  end
end