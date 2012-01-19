require "test/unit"
require "rack/test"

require "sinatra/subdomain"

class Test::Unit::TestCase
  include Rack::Test::Methods
end
