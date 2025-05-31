lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "claiss/version"

Gem::Specification.new do |s|
  s.name        = 'claiss'
  s.version     = CLAISS::VERSION
  s.required_ruby_version = '>= 2.7.0'
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Ferramenta CLI para refatoração de código em lote"
  s.description = <<-DESC
    CLAISS é uma ferramenta poderosa para refatoração de código em lote, permitindo
    renomear e substituir termos em múltiplos arquivos de forma segura e eficiente.
    Inclui recursos como visualização de diferenças, modo de simulação e correção
    automática de permissões para projetos Ruby.
  DESC
  s.authors     = ['Júlio Papel']
  s.email       = ['julio.papel@gmail.com']
  s.homepage    = 'https://github.com/JulioPapel/claiss'
  s.license     = 'MIT'
  
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
  s.add_dependency "json", '~> 2.10.2'
  s.add_dependency "diffy", '~> 3.4.3'
  
  # Dependências de desenvolvimento
  s.add_development_dependency "rspec", "~> 3.12"
  s.add_development_dependency "rspec-mocks", "~> 3.12"
  s.add_development_dependency "rspec_junit_formatter", "~> 0.6.0"
  s.add_development_dependency "simplecov", "~> 0.22.0"
  s.add_development_dependency "webmock", "~> 3.19"
  s.add_development_dependency "pry-byebug", "~> 3.10"
  s.add_development_dependency "rake", "~> 13.0"
end