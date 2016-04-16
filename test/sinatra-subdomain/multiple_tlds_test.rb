require "test_helper"

class MultipleTldsTest < Minitest::Test
  include SubdomainTests
  let(:tld) { ".com.br" }
end
