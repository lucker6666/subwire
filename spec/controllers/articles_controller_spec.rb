require 'spec_helper'

# FIXME doesn't work. need an integration test here!

describe ArticlesController do
  before (:each) do
    @channel = FactoryGirl.create(:channel)
    @rel = @channel.relationships.first
    @article = @channel.articles.first

    # Log in first
    sign_in @rel.user
  end

  describe 'POST ajax_mark_as_important' do
    it "should be marked as important" do

      post :ajax_mark_as_important, {:id => @article.id, :is_important => true}

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

  describe "POST add summary change" do
    before do
      Comment.destroy_all
    end

    it "should create comment containing summary change" do
      post :update, :id => @article.id, :article => {:content => 'test'}, :change_summary => 'short summary'

      Comment.find_all_by_article_id(@article.id).should have(1).comment
    end

    it "should not create due to empty summary change" do
      post :update, :id => @article.id, :article => {:content => 'test'}, :change_summary => nil

      Comment.find_all_by_article_id(@article.id).should be_empty
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
  # end
end
