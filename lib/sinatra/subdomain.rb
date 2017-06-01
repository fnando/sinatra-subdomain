require "sinatra/base"
require "uri"
require "resolv"

module Sinatra
  module Subdomain
    class << self
      attr_accessor :app, :subdomain
    end

    module Helpers
      def subdomain
        uri = URI.parse("http://#{request.env["HTTP_HOST"]}")
        return if Sinatra::Subdomain.ip_address?(uri.host)
        parts = uri.host.split(".")
        parts.pop(settings.tld_size + 1)

        parts.empty? ? nil : parts.join(".")
      end
    end

    def subdomain(expected_subdomain = true)
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

    def self.ip_address?(host)
      host =~ Resolv::IPv4::Regex || host =~ Resolv::IPv6::Regex
    end

    def self.match_subdomain?(expected, actual)
      expected.any? do |expected_subdomain|
        case expected_subdomain
        when true
          !actual.nil?
        when Symbol
          actual.to_s == expected_subdomain.to_s
        else
          expected_subdomain === actual
        end
      end
    end

    def self.route_added(verb, _path, _block)
      return unless subdomain && app

      routes = app.instance_variable_get("@routes")
      last_route = routes[verb].last
      expected = [subdomain].flatten.compact

      condition = app.instance_eval do
        generate_method :subdomain do
          ::Sinatra::Subdomain.match_subdomain?(expected, subdomain)
        end
      end

      add_condition(last_route, condition)
    end

    if Gem::Requirement.create(["~>2.0"]).satisfied_by?(Gem::Version.create(Sinatra::VERSION))
      def self.add_condition(last_route, condition)
        last_route[1] << condition
      end
    else
      def self.add_condition(last_route, condition)
        last_route[2] << condition
      end
    end

    def self.registered(app)
      app.helpers Sinatra::Subdomain::Helpers
      app.set :tld_size, 1
    end
  end

  register Subdomain
end
