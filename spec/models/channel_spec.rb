require 'spec_helper'

describe Channel do
  describe "Associations" do
    it { should have_many(:articles) }
    it { should have_many(:availabilities) }
    it { should have_many(:notifications) }
    it { should have_many(:relationships) }
    it { should have_many(:users), through: :relationships }
  end

  describe "Validation" do
    it { should validate_presence_of(:name) }
  end

  describe "Respond to" do
    it { should respond_to(:article_count) }
    it { should respond_to(:notification_count) }
    it { should respond_to(:user_count) }
  end
end