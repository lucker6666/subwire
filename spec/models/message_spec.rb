require 'spec_helper'

describe Message do
  describe "Associations" do
    it { should belong_to(:channel) }
    it { should belong_to(:user) }
    it { should have_many(:comments) }
  end

  describe "Mass assignment" do
    it { should_not allow_mass_assignment_of(:channel_id) }
    it { should_not allow_mass_assignment_of(:user_id) }
  end

  describe "Validation" do
    it { should validate_presence_of(:content) }
  end

  describe "Respond to" do
    it { should respond_to(:newest_comments) }
  end
end