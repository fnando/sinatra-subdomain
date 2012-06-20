require "rubygems"
require "rack/test"
require "sinatra/subdomain"
require "yaml"

Dir["spec/support/**/*.rb"].each {|file| load file }

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
