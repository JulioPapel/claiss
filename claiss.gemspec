Gem::Specification.new do |s|
  s.name      = 'claiss'
  s.version   = '1.0.7'
  s.required_ruby_version = '>= 2.7.0'
  s.platform  = Gem::Platform::RUBY
  s.description = "CLI application Toolbox to manage Laiss AI applications and deployments. Some thing may not work on your environment. Use with caution!"
  s.summary     = "Laiss AI CLI application Toolbox"
  s.authors   = ['Júlio Papel']
  s.email     = ['julio.papel@gmail.com']
  s.homepage  = 'http://rubygems.org/gems/claiss'
  s.license   = 'MIT'
  s.files     = Dir.glob("{lib,exe}/**/*") # This includes all files under the lib directory recursively, so we don't have to add each one individually.
  s.require_path = 'lib'
  s.bindir        = "exe"
  s.executables = ['claiss']
  s.metadata    = { "source_code_uri" => "https://github.com/JulioPapel/claiss.git" }
  s.metadata    = { "documentation_uri" => "https://github.com/JulioPapel/claiss/blob/main/readme.md",}
 
  s.add_dependency "dry-cli", '~> 1.0.0'
  s.add_dependency "pathname", '~> 0.2.1'
  s.add_dependency "fileutils", '~> 1.7.1'
  s.add_dependency "json", '~> 2.6.3'

end
