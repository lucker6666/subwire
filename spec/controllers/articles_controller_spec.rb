require 'spec_helper'

# FIXME doesn't work. need an integration test here!

describe ArticlesController do
  before (:each) do
    @rel = FactoryGirl.create(:user1_with_channel)
    sign_in @rel.user
    set_current_channel @rel.channel
  end

  describe 'POST ajax_mark_as_important' do

    it "should be marked as important" do
      article = Article.new
      article.channel = current_channel
      article.user = current_user
      article.title = "Test"
      article.content = "Test it for happiness!"
      article.is_important = false
      article.save

      post :ajax_mark_as_important, {:id => article.id, :is_important => true}

      response.should be_success
      JSON.parse(response.body)['r'].should be_true
      assigns[:article].is_important?.should be_true
    end
  end

  describe "POST create" do
    it "should create article with editable set on true" do
      article = Article.new
      article.id = 1
      article.is_editable = true
      article.should_receive(:save).and_return(true)
      Article.should_receive(:new).and_return(article)
      Notification.stub(:notify_all_users)

      post :create

      assigns[:article].should_not be_nil
      assigns[:article].is_editable.should be_true
    end
  end


  # describe "GET 'index'" do
  #   context "and user is assigned to the choosen channel" do

  #   end

  #   context "and user is not assigned to the chosen channel" do
  #     context "but is superadmin" do
  #       before (:each) do
  #         @rel = FactoryGirl.create(:admin)
  #         sign_in @rel.user
  #       end

  #       it "should render articles index of that channel" do
  #         response.should render_template('articles/index')
  #       end

  #       it "should assign @articles variable" do
  #         assigns[:articles].should_not be_nil
  #       end

  #       it "should assign only articles of that channel to @articles" do
  #         assigns[:articles].each do |article|
  #           article.channel_id.should eq current_channel.id
  #         end
  #       end

  #       it "should assign @all_notifications variable" do
  #         assigns[:all_notifications].should_not be_nil
  #       end

  #       it "should assign @unread_notification_count" do
  #         assigns[:unread_notification_count].should_not be_nil
  #       end

  #       it "should assign @sidebar_users" do
  #         assigns[:sidebar_users].should_not be_nil
  #       end

  #       it "should push all users, which are assigned to that channel, to @sidebar_users" do
  #         assigns[:sidebar_users].each do |user|
  #           Relationship.find_by_channel_and_user(current_channel, user).any?.should be true
  #         end
  #       end

  #       it "should assign @sidebar_links" do
  #         assigns[:sidebar_links].should_not be_nil
  #       end

  #       it "should only push all links of that channel to @sidebar_links" do
  #         assigns[:@sidebar_links].each do |link|
  #           link.channel_id.should eq current_channel.id
  #         end
  #       end

  #       it "should assign @subwireTitle which should be the name of that channel" do
  #         assigns[:subwireTitle].should be current_channel.name
  #       end
  #     end

  #     context "and no superadmin" do
  #       it "should redirect back to the channel chooser" do
  #         @rel1 = FactoryGirl.create(:user1_with_channel)

  #         # Then choose a channel to which the current user is not assigned to
  #         controller(ApplicationController)
  #         get 'channels/' + @rel1.channel.id + '/show'
  #         controller(ArticlesController)
  #         # set_current_channel @rel1.channel

  #         # Then request the startpage
  #         get :index
  #         response.should redirect_to(channels_url)
  #         current_channel.should be_nil
  #       end
  #     end
  #   end
  # end
end
