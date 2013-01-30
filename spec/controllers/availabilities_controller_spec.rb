require 'spec_helper'

describe AvailabilitiesController do
  before (:each) do
    @channel = FactoryGirl.create(:channel)
    @rel = @channel.relationships.first
  end

  describe "GET 'set'" do
    context "while not authorized" do
      it "should not set an availability" do
        get :set, value: 1, date: Date.today
        Availability.all.any?.should be false
      end
    end

    context "while authorized" do
      before do
        # Log in first
        sign_in @rel.user
      end

      it "should set an availability for that date" do
        get :set, value: 1, date: Date.today
        Availability.where(value: 1, date: Date.today).any?.should be false

        get :set, value: 0, date: Date.today - 1
        Availability.where(value: 0, date: Date.today - 1).any?.should be false
      end
    end
  end
end
