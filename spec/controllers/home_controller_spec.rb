require 'spec_helper'

describe HomeController do
	# Get / unauthorized
  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
    	response.should redirect_to(new_user_session_url)
    end
  end
end
