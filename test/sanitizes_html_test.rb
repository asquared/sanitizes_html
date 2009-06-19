require 'test_helper'

class SanitizesHtmlTest < ActiveSupport::TestCase
  test "removes HTML tags it should" do
    p = Page.new
    p.body = '<p><div id="mydiv">asdf</div></p>'
    p.save
    assert p.body == '<p>asdf</p>'
  end

  test "removes non-allowed attributes" do
    p = Page.new
    p.body = '<p><img src="asdf" alt="qwer" /></p>'
    p.save
    puts
    puts p.body
    puts
    assert p.body =~ /src="asdf"/
    flunk if p.body =~ /alt/
  end
end
