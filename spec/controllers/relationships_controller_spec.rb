require 'spec_helper'

describe RelationshipsController do
  after do
    User.find_by_email("test@example.com").destroy
  end

  describe "POST 'create'" do
    it "should create new user relationship" do
      channel = FactoryGirl.create(:channel)
      rel = channel.relationships.first

      # Log in first
      sign_in rel.user

      post :create, :relationship => {:email => "test@example.com", :admin => false}, :invitation_text => "hello123"

      response.should redirect_to relationships_path

    end
  end
end
