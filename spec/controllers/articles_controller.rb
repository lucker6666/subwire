require 'spec_helper'

describe ArticlesController do
  describe "GET 'index'" do
    # Following doesn't work here
    context "and user is not assigned to the chosen channel" do
      context "but is superadmin" do
        it "should render articles index of that channel" do
          # TODO
        end
      end

      context "and no superadmin" do
        it "should redirect back to the channel chooser" do
          @rel1 = FactoryGirl.create(:user1_with_channel)

          # Then choose a channel to which the current user is not assigned to
          set_current_channel @rel1.channel

          # Then request the startpage
          get :index
          response.should redirect_to(channels_url)
          current_channel.should be_nil
        end
      end
    end
  end
end
