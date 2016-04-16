module SubdomainTests
  def app
    @app ||= begin
      _tld = tld

      @app = Class.new(Sinatra::Base) do
        register Sinatra::Subdomain
        set :tld_size, _tld.split(".").size - 1

        subdomain :foo do
          get("/") { "set: #{subdomain}" }
          get("/about") { "set: about #{subdomain}" }
        end

        subdomain do
          get("/") { "any: #{subdomain}" }
          get("/about") { "any: about #{subdomain}" }
        end

        get("/") { "root" }
        get("/about") { "about" }
      end
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
