require 'spec_helper'

describe Page do
  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:channel) }
  end

  describe "Mass assignment" do
    it { should_not allow_mass_assignment_of(:channel_id) }
    it { should_not allow_mass_assignment_of(:user_id) }
  end
end
