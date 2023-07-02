GEM_NAME = "claiss"
GEM_VERSION = "1.0.0"

namespace :claiss do
  path = "/home/rails/laiss/lib/claiss/"

  task :default => :build

  task :build do
    system "gem build " + path + GEM_NAME + ".gemspec"
  end

  task :install => :build do
    system "gem install " + path + GEM_NAME + "-" + GEM_VERSION + ".gem"
  end

  task :publish => :build do
    system 'gem push ' + path + GEM_NAME + "-" + GEM_VERSION + ".gem"
  end

  task :clean do
    system "rm " + path + "*.gem"
  end

end
