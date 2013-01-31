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

  describe :find_by_channel_and_user do
    it "should return a relationship by user and channel" do
      channel = FactoryGirl.create(:channel)
      rel1 = channel.relationships.first

      rel2 = Relationship.find_by_channel_and_user(rel1.channel, rel1.user)

      rel2.should eq(rel1)
    end
  end

  describe :email do
    it "should return the emailadress of the associated user" do
      channel = FactoryGirl.create(:channel)
      rel = channel.relationships.first

      rel.email.should eq(rel.user.email)
    end
  end

  describe :find_all_by_channel_id_and_page do
    it "should return the relationships" do
      channel = FactoryGirl.create(:channel)
      @rels1 = channel.relationships

      @rels2 = Relationship.find_all_by_channel_id_and_page(channel.id, 1)

      (@rels2 - @rels1).should eq([])
    end
  end
end