require 'bundler/gem_tasks'

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

  desc "Clean up built gems"
  task :clean do
    FileUtils.rm_f Dir.glob('claiss-*.gem')
  end
end

task :default => 'claiss:build'