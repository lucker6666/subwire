require 'spec_helper'

describe NotificationsController do
  before (:each) do
    @channel = FactoryGirl.create(:channel)
    @rel = @channel.relationships.first

    # Log in first
    sign_in @rel.user
  end

  it "should test fails" do
    Notification.stub(:all_notifications_count).any_number_of_times.with(@rel.user.id).and_return(3)

    get :ajax_load_all_notifications

    response.should render_template(:partial => 'shared/navbar/_channelSwitcher')
  end
end
