shared_examples_for "subdomain" do
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

  context "when specific subdomain is required" do
    it "renders root page" do
      header "HOST", "foo.example#{tld}"
      get "/"

      last_response.body.should eql("set: foo")
    end

    it "renders about page" do
      header "HOST", "foo.example#{tld}"
      get "/about"

      last_response.body.should eql("set: about foo")
    end
  end

  context "when any subdomain is required" do
    it "renders root page" do
      header "HOST", "mail.example#{tld}"
      get "/"

      last_response.body.should eql("any: mail")
    end

    it "renders about page" do
      header "HOST", "mail.example#{tld}"
      get "/about"

      last_response.body.should eql("any: about mail")
    end
  end

  context "when no subdomain is required" do
    it "renders root page" do
      header "HOST", "example#{tld}"
      get "/"

      last_response.body.should eql("root")
    end

    it "renders about page" do
      header "HOST", "example#{tld}"
      get "/about"

      last_response.body.should eql("about")
    end
  end
end
