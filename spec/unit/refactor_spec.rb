require 'spec_helper'

RSpec.describe CLAISS::Refactor do
  let(:temp_dir) { create_temp_dir }
  let(:source_dir) { File.join(temp_dir, 'source') }
  let(:destination_dir) { File.join(temp_dir, 'destination') }
  let(:rules_file) { File.join(temp_dir, 'rules.json') }
  let(:refactor) { described_class.new }

  before do
    FileUtils.mkdir_p(source_dir)
    FileUtils.mkdir_p(destination_dir)
    
    # Cria um arquivo de regras de exemplo
    rules = {
      'old_text' => 'new_text',
      'OldClass' => 'NewClass',
      'old_method' => 'new_method'
    }
    
    File.write(rules_file, JSON.generate(rules))
  end

  after do
    FileUtils.rm_rf(temp_dir) if Dir.exist?(temp_dir)
  end

  describe '#get_files_to_process' do
    before do
      # Cria alguns arquivos de teste
      File.write(File.join(source_dir, 'test1.rb'), 'class OldClass; def old_method; end; end')
      File.write(File.join(source_dir, 'test2.txt'), 'This is old_text')
      Dir.mkdir(File.join(source_dir, 'subdir'))
      File.write(File.join(source_dir, 'subdir', 'test3.rb'), 'module Test; end')
      
      # Cria um diretório ignorado
      FileUtils.mkdir_p(File.join(source_dir, '.git'))
      File.write(File.join(source_dir, '.git', 'config'), 'git config')
    end

    it 'retorna apenas arquivos, ignorando diretórios' do
      files = refactor.send(:get_files_to_process, source_dir)
      expect(files).to all(be_a(String))
      expect(files.size).to eq(3)
    end

    it 'ignora diretórios na lista IGNORED_DIRECTORIES' do
      files = refactor.send(:get_files_to_process, source_dir)
      expect(files.none? { |f| f.include?('.git/') }).to be true
    end
  end

  describe '#refactor_file' do
    let(:test_file) { File.join(source_dir, 'test.rb') }
    let(:rules) { { 'OldClass' => 'NewClass', 'old_method' => 'new_method' } }
    let(:temp_file) { Tempfile.new(['test', '.rb']) }

    before do
      File.write(test_file, 'class OldClass; def old_method; end; end')
    end

    it 'substitui o conteúdo do arquivo de acordo com as regras' do
      refactor.send(:refactor_file, test_file, rules, source_dir, nil)
      content = File.read(test_file)
      expect(content).to include('class NewClass')
      expect(content).to include('def new_method')
    end

    it 'renomeia o arquivo se o nome corresponder a alguma regra' do
      old_file = File.join(source_dir, 'old_method.rb')
      File.write(old_file, 'test')
      
      refactor.send(:refactor_file, old_file, rules, source_dir, nil)
      expect(File.exist?(old_file)).to be false
      expect(File.exist?(File.join(source_dir, 'new_method.rb'))).to be true
    end
  end

  describe '#replace_in_path' do
    it 'substitui ocorrências no caminho do arquivo' do
      path = 'path/to/old_text/file.rb'
      rules = { 'old_text' => 'new_text' }
      
      result = refactor.send(:replace_in_path, path, rules)
      expect(result).to eq('path/to/new_text/file.rb')
    end
  end

  describe '#load_dictionary' do
    it 'carrega um dicionário de um arquivo JSON' do
      dict = refactor.send(:load_dictionary, rules_file)
      expect(dict).to be_a(Hash)
      expect(dict).to include('old_text' => 'new_text')
    end
  end

  describe 'integração' do
    before do
      # Configura um projeto de teste
      File.write(File.join(source_dir, 'old_file.rb'), 'class OldClass; end')
      File.write(File.join(source_dir, 'other_old_file.txt'), 'This contains old_text')
      
      # Cria um subdiretório com mais arquivos
      subdir = File.join(source_dir, 'old_dir')
      FileUtils.mkdir_p(subdir)
      File.write(File.join(subdir, 'helper.rb'), 'module OldHelper; end')
    end

    it 'processa todos os arquivos e aplica as substituições' do
      # Executa o refatoramento
      refactor.call(path: source_dir, rules: rules_file, destination: destination_dir)
      
      # Verifica se os arquivos foram copiados e processados corretamente
      expect(File.exist?(File.join(destination_dir, 'old_file.rb'))).to be true
      expect(File.exist?(File.join(destination_dir, 'other_old_file.txt'))).to be true
      expect(File.exist?(File.join(destination_dir, 'old_dir', 'helper.rb'))).to be true
      
      # Verifica o conteúdo dos arquivos
      expect(File.read(File.join(destination_dir, 'old_file.rb'))).to include('class NewClass')
      expect(File.read(File.join(destination_dir, 'other_old_file.txt'))).to include('This contains new_text')
      
      # Verifica se os diretórios vazios foram removidos do diretório de origem
      # quando não há diretório de destino
      if destination_dir.nil?
        expect(Dir.exist?(File.join(source_dir, 'old_dir'))).to be false
      else
        # Quando há um diretório de destino, o diretório de origem deve permanecer inalterado
        expect(Dir.exist?(File.join(source_dir, 'old_dir'))).to be true
      end
    end
  end
end
