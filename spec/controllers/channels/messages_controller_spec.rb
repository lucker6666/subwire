require 'spec_helper'

# FIXME doesn't work. need an integration test here!

describe Channels::MessagesController do
  before (:each) do
    @channel = FactoryGirl.create(:channel)
    @rel = @channel.relationships.first
    @message = @channel.messages.first

    # Log in first
    sign_in @rel.user
  end

  # Doesn't work ... don't no why
  # describe 'POST ajax_mark_as_important' do
  #   it "should be marked as important" do
  #     post :mark_as_important, channel_id: @channel.id, id: @message.id, is_important: true

  #     response.should be_success
  #     JSON.parse(response.body)['r'].should be_true
  #     assigns[:message].is_important?.should be_true
  #   end
  # end

  describe "POST create" do
    it "should create message with editable set on true" do
      message = Message.new
      message.id = 1
      message.is_editable = true
      message.content = 'foobar'
      message.should_receive(:save).and_return(true)
      Message.should_receive(:new).and_return(message)
      Notification.stub(:notify_all_users)

      post :create, channel_id: @channel.id

      assigns[:message].should_not be_nil
      assigns[:message].is_editable.should be_true
    end
  end

  describe "POST add summary change" do
    before do
      Comment.destroy_all
    end

    it "should create comment containing summary change" do
      post :update,
        channel_id: @channel.id,
        id: @message.id,
        message: {content: 'test'},
        change_summary: 'short summary'

      Comment.find_all_by_message_id(@message.id).should have(1).comment
    end

    it "should not create due to empty summary change" do
      post :update,
        channel_id: @channel.id,
        id: @message.id,
        message: {content: 'test'},
        change_summary: nil

      Comment.find_all_by_message_id(@message.id).should be_empty
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

  #       it "should render messages index of that channel" do
  #         response.should render_template('messages/index')
  #       end

  #       it "should assign @messages variable" do
  #         assigns[:messages].should_not be_nil
  #       end

  #       it "should assign only messages of that channel to @messages" do
  #         assigns[:messages].each do |message|
  #           message.channel_id.should eq current_channel.id
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
