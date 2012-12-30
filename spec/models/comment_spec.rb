require 'spec_helper'

describe Comment do
  describe "Associations" do
    it { should belong_to(:article) }
    it { should belong_to(:user) }
  end

  describe "Mass assignment" do
    it { should_not allow_mass_assignment_of(:user_id) }
  end

  describe "Validation" do
    it { should validate_presence_of(:content) }
  end
end