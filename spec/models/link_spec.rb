require 'spec_helper'

describe Link do
  it "should move position to up" do
    l = Link.new :position => 5
    l.move_position_up!
    l.position.should be(4)
  end

  it "should move position to dn" do
    l = Link.new :position => 5
    l.move_position_dn!
    l.position.should be(6)
  end

  it "should set next position" do
    l = Link.new :href => 'http://example.com', :name => 'name', :icon => 'icon'
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
end