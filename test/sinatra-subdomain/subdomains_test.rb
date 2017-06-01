require "test_helper"

class SubdomainsTest < Minitest::Test
  def app
    App
  end

  test "renders listed subdomain (a)" do
    header "HOST", "a.example.com"
    get "/"

    assert_equal "array: a", last_response.body
  end

  test "renders listed subdomain (b)" do
    header "HOST", "b.example.com"
    get "/"

    assert_equal "array: b", last_response.body
  end

  test "renders matched subdomain (c)" do
    header "HOST", "c.example.com"
    get "/"

    assert_equal "regex: c", last_response.body
  end

  test "renders matched subdomain (d)" do
    header "HOST", "d.example.com"
    get "/"

    assert_equal "regex: d", last_response.body
  end
end
