require 'spec_helper'

describe RelationshipsController do
  describe "POST 'create'" do
    it "should create new user relationship" do
      log_in_user

      post :create, :relationship => {:email => "test@com.com", :admin => false}, :invitation_text => "hello123"

      response.should redirect_to relationships_path
    end
  end
end
