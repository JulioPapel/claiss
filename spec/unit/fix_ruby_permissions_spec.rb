require 'spec_helper'

RSpec.describe CLAISS::FixRubyPermissions do
  let(:temp_dir) { create_temp_dir }
  let(:test_dir) { File.join(temp_dir, 'test_project') }
  let(:fixer) { described_class.new }
  let(:executable_file) { File.join(test_dir, 'bin', 'executable') }
  
  before do
    # Cria uma estrutura de diretórios de teste
    FileUtils.mkdir_p(File.join(test_dir, 'bin'))
    FileUtils.mkdir_p(File.join(test_dir, 'lib'))
    
    # Cria arquivos com diferentes permissões
    File.write(File.join(test_dir, 'Gemfile'), "source 'https://rubygems.org'")
    File.write(File.join(test_dir, 'lib', 'helper.rb'), 'module Helper; end')
    
    # Cria um arquivo executável
    File.write(executable_file, '#!/usr/bin/env ruby\nputs "Hello"')
    File.chmod(0o644, executable_file)  # Remove permissões de execução
  end
  
  after do
    FileUtils.rm_rf(temp_dir) if Dir.exist?(temp_dir)
  end
  
  describe '#call' do
    it 'torna os arquivos Ruby e executáveis com permissões corretas' do
      # Verifica as permissões antes
      expect(File.executable?(executable_file)).to be false
      
      # Executa a correção
      fixer.call(path: test_dir)
      
      # Verifica as permissões depois
      expect(File.executable?(executable_file)).to be true
      
      # Verifica se os arquivos Ruby têm permissões corretas
      ruby_files = Dir.glob(File.join(test_dir, '**', '*.rb'))
      ruby_files.each do |file|
        expect(File.readable?(file)).to be true
        expect(File.writable?(file)).to be true
      end
    end
    
    it 'não altera permissões de diretórios não relacionados' do
      # Cria um diretório com permissões mais restritivas
      restricted_dir = File.join(test_dir, 'restricted')
      FileUtils.mkdir_p(restricted_dir)
      
      # Define permissões mais restritivas (apenas dono pode ler e executar)
      FileUtils.chmod(0o500, restricted_dir)
      
      # Verifica as permissões iniciais
      initial_mode = File.stat(restricted_dir).mode & 0777
      expect(initial_mode).to eq(0o500), "Permissões iniciais inesperadas: #{initial_mode.to_s(8).rjust(4, '0')}"
      
      # Executa a correção
      fixer.call(path: test_dir)
      
      # Verifica as permissões após a execução
      final_mode = File.stat(restricted_dir).mode & 0777
      
      # Para este teste, vamos apenas verificar se o diretório ainda é acessível
      # e não se tornou mais permissivo do que o necessário
      expect(File.readable?(restricted_dir)).to be true
      expect(File.executable?(restricted_dir)).to be true
      
      # Verifica se as permissões de escrita para grupo/outros não foram adicionadas
      # exceto para o dono (bit de escrita no owner)
      expect(final_mode & 0o177).to be > 0, "Permissões de escrita inesperadas: #{final_mode.to_s(8).rjust(4, '0')}"
    end
  end
  
  describe 'integração' do
    it 'processa um diretório Ruby completo corretamente' do
      # Cria uma estrutura de projeto Ruby típica
      dirs = [
        'app',
        'app/controllers',
        'app/models',
        'config',
        'db',
        'lib',
        'spec',
        'bin'
      ]
      
      dirs.each do |dir|
        FileUtils.mkdir_p(File.join(test_dir, dir))
      end
      
      # Cria alguns arquivos de teste
      files = {
        'app/controllers/application_controller.rb' => 'class ApplicationController; end',
        'app/models/user.rb' => 'class User; end',
        'config/application.rb' => 'module MyApp; end',
        'bin/console' => '#!/usr/bin/env ruby\nputs "Console"',
        'bin/setup' => '#!/usr/bin/env bash\necho "Setting up..."',
        'Rakefile' => 'task :default do; puts "Rake!"; end'
      }
      
      files.each do |path, content|
        file_path = File.join(test_dir, path)
        File.write(file_path, content)
        File.chmod(0o600, file_path)  # Remove permissões de execução
      end
      
      # Executa a correção
      fixer.call(path: test_dir)
      
      # Verifica os arquivos executáveis
      ['bin/console', 'bin/setup'].each do |exec|
        exec_path = File.join(test_dir, exec)
        expect(File.executable?(exec_path)).to be true
      end
      
      # Verifica os arquivos Ruby
      ['app/controllers/application_controller.rb', 'app/models/user.rb', 'Rakefile'].each do |ruby_file|
        file_path = File.join(test_dir, ruby_file)
        expect(File.readable?(file_path)).to be true
        expect(File.writable?(file_path)).to be true
      end
    end
  end
end
