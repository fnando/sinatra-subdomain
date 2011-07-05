require "sinatra/base"
require "uri"

module Sinatra
  module Subdomain
    module Helpers
      def subdomain
        uri = URI.parse("http://#{request.env["HTTP_HOST"]}")
        parts = uri.host.split(".")
        parts.pop(settings.tld_size + 1)
        parts.first
      end
    end

    def subdomain(expected_subdomain = nil, &block)
      condition do
        if expected_subdomain
          expected_subdomain.to_s == subdomain
        elsif subdomain
          true
        else
          false
        end
      end

      yield
    end

    def self.registered(app)
      app.helpers Sinatra::Subdomain::Helpers
      app.set :tld_size, 1
    end
  end

  register Subdomain
end
