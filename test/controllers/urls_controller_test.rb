require "test_helper"

class UrlsControllerTest < ActionDispatch::IntegrationTest
  test "should get encode" do
    get urls_encode_url
    assert_response :success
  end

  test "should get decode" do
    get urls_decode_url
    assert_response :success
  end
end
