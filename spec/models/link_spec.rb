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
  end

  describe "Respond to" do
    it { should respond_to(:move_position_up!) }
    it { should respond_to(:move_position_dn!) }
  end

  it "should move position to up" do
    l1 = Link.new position: 1, name: "dummy", href: "http://example.com"
    l2 = Link.new position: 2, name: "dummy", href: "http://example.com"

    l1.save!
    l2.save!

    l2.position.should be(2)
    l2.move_position_up!
    Link.find(l2.id).position.should be(1)
  end

  it "should move position to dn" do
    l1 = Link.new position: 1, name: "dummy", href: "http://example.com"
    l2 = Link.new position: 2, name: "dummy", href: "http://example.com"

    l1.save!
    l2.save!

    l2.position.should be(2)
    l2.move_position_up!
    Link.find(l2.id).position.should be(1)
  end

  it "should set next position" do
    l = Link.new href: 'http://example.com', name: 'name'
    l.channel_id = 1
    l.save!

    l = Link.new
    l.href = 'http://example.com'
    l.name = 'name'
    l.channel_id = 1
    l.position.should eq(0)
    l.save
    l.position.should eq(2)
  end

  it "Find all links by channel and page" do
    channel = FactoryGirl.create(:channel)
    link = Link.new href: 'http://example.com', name: 'name'
    link.channel = channel
    link.save!

    Link.find_all_by_channel_id_and_page(channel.id, 1).first.id.should eq(link.id)
  end
end