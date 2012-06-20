require "test_helper"

class SubdomainTest < Test::Unit::TestCase
  class SubdomainTestApp < Sinatra::Base
    register Sinatra::Subdomain

    subdomain :foo do
      get("/") { "set: #{subdomain}" }
    end

    subdomain do
      get("/") { "any: #{subdomain}" }
    end

    get("/") { "root" }
  end

  def app
    SubdomainTestApp
  end

  def test_specified_subdomain
    header "HOST", "foo.example.org"
    get "/"

    assert_equal "set: foo", last_response.body
  end

  def test_any_subdomain
    header "HOST", "status.example.org"
    get "/"
    assert_equal "any: status", last_response.body

    header "HOST", "mail.example.org"
    get "/"
    assert_equal "any: mail", last_response.body
  end

  def test_root
    header "HOST", "example.org"
    get "/"

    assert_equal "root", last_response.body
  end
end
