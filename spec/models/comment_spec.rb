require 'spec_helper'

describe Comment do
  describe "Associations" do
    it { should belong_to(:message) }
    it { should belong_to(:user) }
  end

  describe "Mass assignment" do
    it { should_not allow_mass_assignment_of(:user_id) }
  end

  describe "Validation" do
    it { should validate_presence_of(:content) }
  end

  describe :newest_comments do
    before do
      @message = FactoryGirl.create(:channel).messages.first
    end

    it "sould return all comments of that message" do
      @message.newest_comments.should eq(Comment.newest.find_all_by_message_id(@message.id))
    end
  end
end