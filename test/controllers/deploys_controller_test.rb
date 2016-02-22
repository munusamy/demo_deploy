require 'test_helper'

class DeploysControllerTest < ActionController::TestCase
  test "should get details" do
    get :details
    assert_response :success
  end

end
