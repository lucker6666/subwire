require 'spec_helper'

describe Channel do
  describe "Associations" do
    it { should have_many(:articles) }
    it { should have_many(:availabilities) }
    it { should have_many(:notifications) }
    it { should have_many(:relationships) }
    it { should have_many(:users).through(:relationships) }
  end

  describe "Mass assignment" do
    it { should_not allow_mass_assignment_of(:channel_id) }
    it { should_not allow_mass_assignment_of(:user_id) }
  end

  describe "Validation" do
    it { should validate_presence_of(:name) }
    it { should ensure_length_of(:name).is_at_most(30) }
    it { should ensure_inclusion_of(:defaultLanguage).in_array(['en', 'de']) }
  end

  describe "Respond to" do
    it { should respond_to(:article_count) }
    it { should respond_to(:notification_count) }
    it { should respond_to(:user_count) }
  end

  describe :find_all_by_user do
    it "should find all channels by user" do
      channel = FactoryGirl.create(:channel)
      rel = channel.relationships.first

      Channel.find_all_by_user(rel.user).first.id.should eq(channel.id)
    end
  end

  describe :article_count do
    it "should count all his articles" do
      channel = FactoryGirl.create(:channel)
      rel = channel.relationships.first

      articles = Article.find_all_by_channel_id(channel.id).length
      rel.channel.article_count.should eq(articles)
    end
  end

  describe :user_count do
    it "should count all his users" do
      channel = FactoryGirl.create(:channel)
      rel = channel.relationships.first

      channel.user_count.should eq(4)
    end
  end

  describe :notification_count do
    it "should count notifications for a user" do
      @channel = FactoryGirl.create(:channel)
      @rels = @channel.relationships

      data = {
        notification_type: :new_article,
        provokesUser: @rels[1].user,
        subject: "Test",
        href: "/"
      }

      Notification.notify_all_users(data, @channel, @rels[0].user)
      Notification.notify_all_users(data, @channel, @rels[0].user)

      @channel.notification_count(@rels[2].user).should eq(2)
    end
  end
end