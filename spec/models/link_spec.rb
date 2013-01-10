require 'spec_helper'

describe Link do
  describe "Associations" do
    it { should belong_to(:channel) }
  end

  describe "Mass assignment" do
    it { should_not allow_mass_assignment_of(:channel_id) }
  end

  describe "Validation" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:href) }
    it { should validate_presence_of(:icon) }
  end

  describe "Respond to" do
    it { should respond_to(:move_position_up!) }
    it { should respond_to(:move_position_dn!) }
  end

  it "should move position to up" do
    l = Link.new position: 5
    l.move_position_up!
    l.position.should be(4)
  end

  it "should move position to dn" do
    l = Link.new position: 5
    l.move_position_dn!
    l.position.should be(6)
  end

  it "should set next position" do
    l = Link.new href: 'http://example.com', name: 'name', icon: 'icon'
    l.channel_id = 1
    l.save

    l = Link.new
    l.href = 'http://example.com'
    l.name = 'name'
    l.icon = 'icon'
    l.channel_id = 1
    l.position.should eq(0)
    l.save
    l.position.should eq(2)
  end

  it "Find all links by channel and page" do
    channel = FactoryGirl.create(:channel1)
    link = Link.new href: 'http://example.com', name: 'name', icon: 'icon'
    link.channel = channel
    link.save!

    Link.find_all_by_channel_id_and_page(channel.id, 1).first.id.should eq(link.id)
  end
end