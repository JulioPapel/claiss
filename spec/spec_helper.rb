require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/.bundle/'
  add_filter '/.gem/'
  add_filter '/.git/'
end

require 'claiss'
require 'fileutils'
require 'tempfile'
require 'pry-byebug'

RSpec.configure do |config|
  # Habilita a sintaxe `expect`
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # Habilita mocks
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Compartilha contexto entre testes
  config.shared_context_metadata_behavior = :apply_to_host_groups
  
  # Configura para limpar arquivos temporários após os testes
  config.after(:suite) do
    FileUtils.rm_rf(Dir["#{__dir__}/../tmp"])
  end
end

# Helper para criar arquivos temporários
def create_temp_file(content, extension = '')
  temp_file = Tempfile.new(['test', extension])
  temp_file.write(content)
  temp_file.close
  temp_file
end

# Helper para criar diretório temporário
def create_temp_dir(prefix = 'test_dir')
  Dir.mktmpdir(prefix)
end
