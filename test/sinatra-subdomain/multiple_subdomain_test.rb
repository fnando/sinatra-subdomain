# frozen_string_literal: true

require "test_helper"

class MultipleSubdomainTest < Minitest::Test
  include SubdomainTests
  let(:tld) { ".com" }
end
