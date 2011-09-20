require "test/unit"
require "rack/test"
require "capybara"
require "capybara/dsl"

require "sinatra/subdomain"

Capybara.default_driver = :selenium

class Test::Unit::TestCase
  include Capybara::DSL
end

class SampleApp < Sinatra::Base
  register Sinatra::Subdomain

  subdomain :foo do
    get("/") { "set: #{subdomain}" }
  end

  subdomain do
    get("/") { "any: #{subdomain}" }
  end

  get("/") { "root" }
end

class MultipleTldsApp < Sinatra::Base
  register Sinatra::Subdomain
  set :tld_size, 2

  subdomain :foo do
    get("/") { "set: #{subdomain}" }
  end

  subdomain do
    get("/") { "any: #{subdomain}" }
  end

  get("/") { "root" }
end
