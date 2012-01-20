require "rack/test"
require "sinatra/subdomain"
require "yaml"

Dir["spec/support/**/*.rb"].each {|file| require file }

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
