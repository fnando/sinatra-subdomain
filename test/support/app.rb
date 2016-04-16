class App < Sinatra::Base
  register Sinatra::Subdomain

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
