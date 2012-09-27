require 'spec_helper'

describe ChannelsController do
  before (:each) do
    @rel = FactoryGirl.create(:user2_with_channel)
  end

  it "should redirect to login page when not authorized" do
    get :index
    response.should redirect_to(new_user_session_url)
  end

  context "while authorized" do
    before do
      # Log in first
      sign_in @rel.user
    end

    context "get 'index'" do
      before do
        get :index
      end

      it "should be successful" do
        response.should be_success
      end

      it "should find at least one channel" do
        assigns[:channels].any?.should be true
      end

      it "should only find the channels the user is assigned to" do
        assigns[:channels].each do |channel|
          rels = Relationship.where(
            channel_id: channel.id,
            user_id: @rel.user.id
          )

          rels.any?.should be true
        end
      end

      it "should set a @adminCount variable which should be 1" do
        assigns[:adminCount].should == 1
      end

      it "should find all unread notifications" do
        # TODO
      end

      it "should render the index page in the login layout" do
        response.should render_template(['layouts/login', 'channels/index'])
      end
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

      context "while not superadmin and already got 5 instances" do
        # TODO
      end

      context "while not superadmin but got less then 5 instances" do
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

    # TODO: POST /channels
    # TODO: PUT /channels/1
    # TODO: DELETE /channels/1

    context "get 'unset'" do
      before do
        get :unset
      end

      it "should unset the current channel" do
        current_channel.should be nil
      end

      it "should redirect to channel overview" do
        response.should redirect_to(channels_path)
      end
    end

    # TODO: GET /channels/all
  end
end
