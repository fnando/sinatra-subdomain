# frozen_string_literal: true

class App < Sinatra::Base
  register Sinatra::Subdomain

  subdomain :foo do
    get("/") { "set: #{subdomain}" }
    get("/about") { "set: about #{subdomain}" }
  end

  subdomain "foo.bar" do
    get("/") { "multiple: #{subdomain}" }
    get("/about") { "multiple: about #{subdomain}" }
  end

  subdomain [:a, :b] do
    get("/") { "array: #{subdomain}" }
  end

  subdomain(/\A(c|d)\z/) do
    get("/") { "regex: #{subdomain}" }
  end

  subdomain(->(actual) { actual == "e" }) do
    get("/") { "proc: #{subdomain}" }
  end

  subdomain do
    get("/") { "any: #{subdomain}" }
    get("/about") { "any: about #{subdomain}" }
  end

  get("/") { "root" }
  get("/about") { "about" }
end
