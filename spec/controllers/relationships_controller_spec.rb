require 'spec_helper'

describe RelationshipsController do
  before (:each) do
    @channel = FactoryGirl.create(:channel)
    @rel = @channel.relationships.first
  end

  describe "POST 'create'" do
    it "should create new user relationship" do
      # Log in first
      sign_in @rel.user

      post :create,
        channel_id: @rel.channel.id,
        relationship: {
          email: "test@example.com",
          admin: false
        },
        invitation_text: "hello123"

      # TODO a mail should be sent
      # TODO a new user should be created

      response.should redirect_to channel_relationships_path(@rel.channel)
    end
  end
end
