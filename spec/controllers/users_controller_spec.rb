require 'spec_helper'

describe UsersController do
  before (:each) do
    @rel = FactoryGirl.create(:user2_with_instance)
    sign_in @rel.user
    set_current_instance @rel.instance
  end

  describe "GET 'show'" do
    it "should be successful" do
      get :show, :id => @rel.user.id
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @rel.user.id
      assigns(:user).should == @rel.user
    end
  end
end