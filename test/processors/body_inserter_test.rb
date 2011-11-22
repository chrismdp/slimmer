require "test_helper"

class BodyInserterTest < MiniTest::Unit::TestCase
  def test_should_replace_contents_of_wrapper_in_template
    template = as_nokogiri %{
      <html><body><div><div id="wrapper"></div></div></body></html>
    }
    source = as_nokogiri %{
      <html><body><nav></nav><div id="wrapper"><p>this should be moved</p></div></body></html>
    }

    Slimmer::BodyInserter.new.filter(source, template)
    assert_in template, "#wrapper", %{<p>this should be moved</p>}
  end

  def test_should_allow_replacement_of_arbitrary_wrappers
    template = as_nokogiri %{
      <html><body><div>
      <div id="wrapper">don't touch this</div>
      <div id="some_other_id"></div></div></body></html>
    }
    source = as_nokogiri %{
      <html><body><div id="some_other_id"><p>this should be moved</p></div></body></html>
    }

    Slimmer::BodyInserter.new("#some_other_id").filter(source, template)
    assert_in template, "#wrapper", %{don't touch this}
    assert_in template, "#some_other_id", %{<p>this should be moved</p>}
  end
end