require "test_helper"

class MultipleTldsTest < Test::Unit::TestCase
  App = Class.new(Sinatra::Base) do
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

  def app
    App
  end

  def test_specified_subdomain
    header "HOST", "foo.example.com.br"
    get "/"

    assert_equal "set: foo", last_response.body
  end

  def test_any_subdomain
    header "HOST", "status.example.com.br"
    get "/"
    assert_equal "any: status", last_response.body

    header "HOST", "mail.example.com.br"
    get "/"
    assert_equal "any: mail", last_response.body
  end

  def test_root
    header "HOST", "example.com.br"
    get "/"

    assert_equal "root", last_response.body
  end
end
