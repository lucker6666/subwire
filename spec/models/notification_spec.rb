require 'spec_helper'

describe Notification do
  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:channel) }
  end

  describe "Mass assignment" do
    it { should_not allow_mass_assignment_of(:channel_id) }
    it { should_not allow_mass_assignment_of(:user_id) }
  end

  describe "Validation" do
    it { should validate_presence_of(:notification_type) }
    it { should validate_presence_of(:href) }
  end

  describe "Respond to" do
    it { should respond_to(:avatar_path) }
    it { should respond_to(:message) }
    it { should respond_to(:read!) }
  end
end