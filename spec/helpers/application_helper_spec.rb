require 'spec_helper'

describe ApplicationHelper do
  describe "#login_background" do
    it "should return a random background hash" do
      Subwire::Application.config.backgrounds.should include(login_background)
    end
  end

  describe :method do
    describe :avatar_path do
      before do
        @channel = FactoryGirl.create('channel')
        @user = @channel.relationships.first.user
      end

      context "while user has not enabled gravatar option" do
        it "should return the avatar path for the respective user" do
          avatar(@user).should include(@user.avatar.url)
        end
      end

      context "while user has enabled gravatar option" do
        it "should return gravatar path for the respective user" do
          gravatar = Digest::MD5.hexdigest(@user.email.strip.downcase)
          @user.gravatar = gravatar
          @user.password = 'foobar'
          @user.password_confirmation = 'foobar'
          @user.save!

          avatar(@user).should include('http://www.gravatar.com/avatar/' + gravatar + '?s=50')
        end
      end
    end
  end
end