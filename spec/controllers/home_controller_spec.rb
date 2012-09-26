require 'spec_helper'

describe HomeController do
  before (:each) do
    @rel = FactoryGirl.create(:user2_with_channel)
  end

  describe "GET 'index'" do
    context "while not authorized" do
      it "should redirect to login form" do
        get :index
        response.should redirect_to(new_user_session_url)
      end
    end

    context "while authorized" do
      before do
        # Log in first
        sign_in @rel.user
      end

      context "but without chosen channel" do
        it "should redirect to channel chooser" do
          get :index
          response.should redirect_to(channels_url)
        end
      end

      context "and with chosen channel" do
        before do
          set_current_channel @rel.channel
          get :index
        end

        it "should redirect to the respective channel" do
          response.should redirect_to(articles_url)
        end

        it "sould have no current_channel set" do
          current_channel.id.should == @rel.channel.id
        end
      end
    end
  end

  describe "GET 'virgin'" do
    before do
      # Log in first
      sign_in @rel.user
    end

    it "should be successful" do
      response.should be_success
    end
  end

  describe "GET 'integration'" do
    render_views

    context "while not authorized" do
      before do
        # Log in first
        get :integration, :locale => 'de'
      end

      it "should be successful" do
        response.should be_success
      end

      it "renders the logged_in action template" do
        response.should render_template("login")
      end
    end

    context "while authorized" do
      before do
        # Log in first
        sign_in @rel.user
        get :integration, :locale => 'de'
      end

      it "should be successful" do
        response.should be_success
      end

      it "renders the login action template" do
        response.should render_template("logged_in")
      end
    end
  end
end