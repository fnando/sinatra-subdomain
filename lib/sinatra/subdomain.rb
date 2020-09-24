# frozen_string_literal: true

require "sinatra/base"
require "uri"
require "resolv"

module Sinatra
  module Subdomain
    class << self
      attr_accessor :app, :subdomain
    end

    SINATRA_V2 = Gem::Requirement.create([">=2.0"]).satisfied_by?(
      Gem::Version.create(Sinatra::VERSION)
    )

    module Helpers
      def subdomain
        uri = URI.parse("http://#{request.env['HTTP_HOST']}")
        return if Sinatra::Subdomain.ip_address?(uri.host)

        parts = uri.host.split(".")
        parts.pop(settings.tld_size + 1)

        parts.empty? ? nil : parts.join(".")
      end
    end

    # This is how this works:
    #
    # 1. Whenever you call `subdomain(&block)`, this is the method that's going
    #    to be executed.
    # 2. For each `subdomain` block, we set the app and subdomain condition as
    #    `Sinatra::Subdomain.app` and `Sinatra::Subdomain.subdomain`.
    # 3. Then, we yield the block, which will add the routes as needed.
    # 4. After each route is added, Sinatra triggers a hook called
    #    `:route_added`, handled by the `routed_added` method below.
    # 5. The `routed_added` method will hijack the routes, adding the subdomain
    #    condition.
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
          expected_subdomain === actual # rubocop:disable Style/CaseEquality
        end
      end
    end

    def self.route_added(verb, _path, _block)
      return unless subdomain && app

      routes = app.instance_variable_get("@routes")
      last_route = routes[verb].last
      expected = [subdomain].flatten.compact

      condition = app.instance_eval do
        generate_method :subdomain_matcher do
          ::Sinatra::Subdomain.match_subdomain?(expected, subdomain)
        end
      end

      add_condition(last_route, condition)
    end

    if SINATRA_V2
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
