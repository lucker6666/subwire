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
end