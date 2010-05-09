require "test_helper"

class MultipleTldsTest < Test::Unit::TestCase
  def setup
    Capybara.app = MultipleTldsApp
  end

  def test_specified_subdomain
    visit "http://foo.smackaho.smackaho.st:9887/"
    assert page.has_content? "set: foo"
  end

  def test_any_subdomain
    visit "http://status.smackaho.smackaho.st:9887/"
    assert page.has_content? "any: status"

    visit "http://mail.smackaho.smackaho.st:9887/"
    assert page.has_content? "any: mail"
  end

  def test_root
    visit "http://smackaho.smackaho.st:9887/"
    assert page.has_content? "root"
  end
end
