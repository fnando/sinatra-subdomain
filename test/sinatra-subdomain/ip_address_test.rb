# frozen_string_literal: true

require "test_helper"

class IpAddressTest < Minitest::Test
  def app
    App
  end

  test "renders no subdomain root page" do
    header "HOST", "127.0.0.1"
    get "/"

    assert_equal "root", last_response.body
  end

  test "renders no subdomain about page" do
    header "HOST", "127.0.0.1"
    get "/about"

    assert_equal "about", last_response.body
  end
end
