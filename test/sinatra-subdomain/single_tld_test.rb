# frozen_string_literal: true

require "test_helper"

class SingleTldTest < Minitest::Test
  include SubdomainTests
  let(:tld) { ".org" }
end
