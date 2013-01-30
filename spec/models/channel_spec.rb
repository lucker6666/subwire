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

  it "should find all channels by user" do
    channel = FactoryGirl.create(:channel)
    rel = channel.relationships.first

    Channel.find_all_by_user(rel.user).first.id.should eq(channel.id)
  end

  it "should count all his articles" do
    channel = FactoryGirl.create(:channel)
    rel = channel.relationships.first

    articles = Article.find_all_by_channel_id(channel.id).length
    rel.channel.article_count.should eq(articles)
  end

  it "should count all his users" do
    channel = FactoryGirl.create(:channel)
    rel = channel.relationships.first

    channel.user_count.should eq(4)
  end
end