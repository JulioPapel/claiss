require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

# Carrega o arquivo de versão para ter acesso à constante VERSION
require_relative 'lib/claiss/version'

# Tarefas do RSpec
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

namespace :test do
  desc 'Executa todos os testes com cobertura de código'
  task :coverage do
    ENV['COVERAGE'] = 'true'
    Rake::Task['spec'].execute
  end

  desc 'Executa testes em paralelo'
  task :parallel do
    sh 'bundle exec parallel_rspec spec/'
  end
end

namespace :claiss do
  desc "Build the gem"
  task :build do
    system "gem build claiss.gemspec"
  end

  desc "Install the gem"
  task :install => :build do
    gem_file = Dir.glob('claiss-*.gem').max_by {|f| File.mtime(f)}
    system "gem install #{gem_file}"
  end

  desc "Publish the gem"
  task :publish do
    gem_file = Dir.glob('claiss-*.gem').max_by {|f| File.mtime(f)}
    system "gem push #{gem_file}"
  end

  desc "Clean up built gems and test artifacts"
  task :clean do
    FileUtils.rm_f Dir.glob('claiss-*.gem')
    FileUtils.rm_rf('coverage')
    FileUtils.rm_rf('tmp')
  end
  
  desc 'Executa os testes antes de publicar'
  task :release => ['test:coverage', :build, :publish, :clean]
end

# Tarefas padrão
task :default => 'spec'

task :test => :spec