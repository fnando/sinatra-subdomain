require "bundler/setup"

require "minitest/utils"
require "minitest/autorun"
require "rack/test"
require "sinatra/subdomain"
require "yaml"

Dir["./test/support/**/*.rb"].each {|file| require file }

module Minitest
  class Test
    include Rack::Test::Methods
  end
end
