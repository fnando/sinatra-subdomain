require "sinatra/base"
require "uri"

module Sinatra
  module Subdomain
    class << self
      attr_accessor :app, :subdomain
    end

    module Helpers
      def subdomain
        uri = URI.parse("http://#{request.env["HTTP_HOST"]}")
        parts = uri.host.split(".")
        parts.pop(settings.tld_size + 1)
        parts.first
      end
    end

    def subdomain(expected_subdomain = true, &block)
      ::Sinatra::Subdomain.tap do |mod|
        mod.app = self
        mod.subdomain = expected_subdomain
      end

      yield

      ::Sinatra::Subdomain.tap do |mod|
        mod.app = nil
        mod.subdomain = nil
      end
    end

    def self.route_added(verb, path, block)
      return unless subdomain && app

      routes = app.instance_variable_get("@routes")
      last_route = routes[verb].last
      expected = subdomain

      condition = app.instance_eval do
        generate_method :subdomain do
          if expected == true
            subdomain != nil
          else
            subdomain.to_s == expected.to_s
          end
        end
      end

      last_route[2] << condition
    end

    def self.registered(app)
      app.helpers Sinatra::Subdomain::Helpers
      app.set :tld_size, 1
    end
  end

  register Subdomain
end
