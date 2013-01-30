require 'spec_helper'

describe UsersController do
  before (:each) do
    @channel = FactoryGirl.create(:channel)
    @rel = @channel.relationships.first

    # Log in first
    sign_in @rel.user
    set_current_channel @channel
  end

  describe "GET 'show'" do
    it "should be successful" do
      get :show, id: @rel.user.id
      response.should be_success
    end

    it "should find the right user" do
      get :show, id: @rel.user.id
      assigns(:user).should == @rel.user
    end
  end
end
