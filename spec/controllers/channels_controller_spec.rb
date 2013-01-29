require 'spec_helper'

describe ChannelsController do
  before (:each) do
    @rel = FactoryGirl.create(:user2_with_channel)
  end

  context "while authorized" do
    before do
      # Log in first
      sign_in @rel.user
    end

    context "get 'show'" do
      before do
        get :show, id: @rel.channel.id
      end

      it "should set the current channel" do
        current_channel.should == @rel.channel
      end

      it "should redirect to aritcle overview" do
        response.should redirect_to(articles_path)
      end
    end

    context "get 'new'" do
      before do
        get :new
      end

      context "while not superadmin and already got 5 channels" do
        # TODO
      end

      context "while not superadmin but got less then 5 channels" do
        it "should be successful" do
          response.should be_success
        end

        it "should assign a @channel variable" do
          #assigns[:channel].should == Channel.new
          # TODO doesn't work !?
        end

        it "should render the 'new' view in the login layout" do
          response.should render_template(['layouts/login', 'channels/new'])
        end
      end
    end

    context "get 'edit'" do
      context "while has no superadmin privileges and not assigned to that channel" do
        # TODO
      end

      context "while has superadmin privileges but not assigned to that channel" do
        # TODO
      end

      context "while has no superadmin privileges but assigend to that channel" do
        before do
          get :edit, id: @rel.channel.id
        end

        it "should be successful" do
          response.should be_success
        end

        it "should assign the @channel variable which should be the channel with ID 1" do
          assigns[:channel].id.should == @rel.channel.id
        end

        it "should render the 'edit' view in the login layout" do
          response.should render_template(['layouts/login', 'channels/edit'])
        end
      end
    end
  end
end
