require 'test_helper'

class ElasticemailTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Elasticemail::VERSION
  end

  def test_that_api_is_a_class
    assert ::Elasticemail::API.is_a? Class
  end

  def test_call_list_blocked_email
    # insert a valid key
    elasticemail = ::Elasticemail::API.new "randomkey"
    assert elasticemail
    response = elasticemail.contact_load_blocked
    assert response.is_a? Array
  end
end
