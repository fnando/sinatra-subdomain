require "test_helper"

class SubdomainTest < Test::Unit::TestCase
  def setup
    Capybara.app = SampleApp
  end

  def test_specified_subdomain
    visit "http://foo.smackaho.st:9887/"
    assert page.has_content? "set: foo"
  end

  def test_any_subdomain
    visit "http://status.smackaho.st:9887/"
    assert page.has_content? "any: status"

    visit "http://mail.smackaho.st:9887/"
    assert page.has_content? "any: mail"
  end

  def test_root
    visit "http://smackaho.st:9887/"
    assert page.has_content? "root"
  end
end
