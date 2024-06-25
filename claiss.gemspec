lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "claiss/version"

Gem::Specification.new do |s|
  s.name      = 'claiss'
  s.version   = CLAISS::VERSION
  s.required_ruby_version = '>= 2.7.0'
  s.platform  = Gem::Platform::RUBY
  s.description = "CLI application Toolbox to manage CLAISS AI applications and deployments. Some features may not work in all environments. Use with caution!"
  s.summary     = "CLAISS AI CLI application Toolbox"
  s.authors   = ['Júlio Papel']
  s.email     = ['julio.papel@gmail.com']
  s.homepage  = 'http://rubygems.org/gems/claiss'
  s.license   = 'MIT'
  
  s.files     = Dir.glob("{lib,exe}/**/*") + %w(LICENSE README.md)
  s.bindir        = "exe"
  s.executables   = ["claiss"]
  s.require_paths = ["lib"]
  
  s.metadata    = {
    "source_code_uri" => "https://github.com/JulioPapel/claiss.git",
    "documentation_uri" => "https://github.com/JulioPapel/claiss/blob/main/readme.md"
  }
  
  s.add_dependency "dry-cli", '~> 1.0.0'
  s.add_dependency "fileutils", '~> 1.7.1'
  s.add_dependency "json", '~> 2.6.3'
end