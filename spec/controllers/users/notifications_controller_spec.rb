require 'spec_helper'

describe Users::NotificationsController do
  before (:each) do
    @channel = FactoryGirl.create(:channel)
    @rel = @channel.relationships.first

    # Log in first
    sign_in @rel.user
  end
end
