module SubdomainTests
  def app
    _tld = tld

    Class.new(App) do
      set :tld_size, _tld.split(".").size - 1
    end
  end

  def self.included(base)
    base.class_eval do
      test "when specific subdomain is required - renders root page" do
        header "HOST", "foo.example#{tld}"
        get "/"

        assert_equal "set: foo", last_response.body
      end

      test "when specific subdomain is required - renders about page" do
        header "HOST", "foo.example#{tld}"
        get "/about"

        assert_equal "set: about foo", last_response.body
      end

      test "when any subdomain is required - renders root page" do
        header "HOST", "mail.example#{tld}"
        get "/"

        assert_equal "any: mail",last_response.body
      end

      test "when any subdomain is required - renders about page" do
        header "HOST", "mail.example#{tld}"
        get "/about"

        assert_equal "any: about mail",last_response.body
      end

      test "when no subdomain is required - renders root page" do
        header "HOST", "example#{tld}"
        get "/"

        assert_equal "root",last_response.body
      end

      test "when no subdomain is required - renders about page" do
        header "HOST", "example#{tld}"
        get "/about"

        assert_equal "about",last_response.body
      end
    end
  end
end
