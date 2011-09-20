require "bundler"
Bundler::GemHelper.install_tasks

desc "Run tests"
task :test do
  # Hack needed: some tests failed when using different Rack apps
  # with rake/testtask
  %w[ subdomain_test.rb multiple_tlds_test.rb ].each do |file|
    system "ruby -rubygems -Ilib -Itest test/#{file}"
  end
end
