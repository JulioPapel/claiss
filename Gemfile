source "https://rubygems.org"

# Especifica o gemspec para carregar as dependências
gemspec

# Dependências de desenvolvimento adicionais
gem 'ruby-progressbar', '~> 1.13.0'
gem 'parallel', '~> 1.27.0'

group :development, :test do
  gem 'rspec', '~> 3.12'
  gem 'rspec-mocks', '~> 3.12'
  gem 'simplecov', '~> 0.22.0', require: false
  gem 'webmock', '~> 3.19'
  gem 'pry-byebug', '~> 3.10'
  gem 'parallel_tests', '~> 4.4.0'
  gem 'rubocop', '~> 1.56', require: false
  gem 'rubocop-rspec', '~> 2.23', require: false
end

gem "diffy", "~> 3.4"

gem "rspec_junit_formatter", "~> 0.6.0", :groups => [:development, :test]
