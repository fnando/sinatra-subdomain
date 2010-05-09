require "jeweler"
require "lib/sinatra/subdomain/version"

desc "Run tests"
task :test do
  # Hack needed: some tests failed when using different Rack apps
  # with rake/testtask
  %w[ subdomain_test.rb multiple_tlds_test.rb ].each do |file|
    system "ruby -rubygems -Ilib -Itest test/#{file}"
  end
end

JEWEL = Jeweler::Tasks.new do |gem|
  gem.name = "sinatra-subdomain"
  gem.email = "fnando.vieira@gmail.com"
  gem.homepage = "http://github.com/fnando/sinatra-subdomain"
  gem.authors = ["Nando Vieira"]
  gem.version = Sinatra::Subdomain::Version::STRING
  gem.summary = "Separate routes for subdomains on Sinatra"
  gem.description = "Separate routes for subdomains on Sinatra"
  gem.add_dependency "sinatra"
  gem.files =  FileList["README.rdoc", "{lib,test}/**/*"]
end

Jeweler::GemcutterTasks.new