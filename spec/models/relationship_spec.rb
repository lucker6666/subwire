require 'spec_helper'

describe Relationship do
  describe "Associations" do
    it { should belong_to(:channel) }
    it { should belong_to(:user) }
  end

  describe "Mass assignment" do
    it { should_not allow_mass_assignment_of(:channel_id) }
    it { should_not allow_mass_assignment_of(:user_id) }
  end

  describe "Respond to" do
    it { should respond_to(:email) }
  end

  it "should return a relationship by user and channel" do
    channel = FactoryGirl.create(:channel)
    rel1 = channel.relationships.first

    rel2 = Relationship.find_by_channel_and_user(rel1.channel, rel1.user)

    rel2.should eq(rel1)
  end
end