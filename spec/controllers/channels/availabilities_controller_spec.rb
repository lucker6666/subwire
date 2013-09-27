require 'spec_helper'

describe Channels::AvailabilitiesController do
  before (:each) do
    @channel = FactoryGirl.create(:channel)
    @rel = @channel.relationships.first
  end

  describe "GET 'set'" do
    context "while not authorized" do
      it "should not set an availability" do
        get :set, channel_id: @channel.id, value: true, date: Date.today
        Availability.all.any?.should be false
      end
    end

    context "while authorized" do
      before do
        # Log in first
        sign_in @rel.user
      end

      it "should set an availability for that date" do
        date = Date.today

        get :set, channel_id: @channel.id, value: true, date: date
        Availability.where(value: true, date: date).any?.should be true

        date -= 1

        get :set, channel_id: @channel.id, value: false, date: date
        Availability.where(value: false, date: date).any?.should be true
      end
    end
  end
end
