require 'spec_helper'

describe NotificationsController do
  before (:each) do
    @rel = FactoryGirl.create(:user1_with_channel)
    sign_in @rel.user
    set_current_channel @rel.channel
  end

  it "should test fails" do
    Notification.stub(:all_notifications_count).any_number_of_times.with(@rel.user.id).and_return(3)

    get :ajax_load_all_notifications

    response.should render_template(:partial => 'shared/navbar/_channelSwitcher')
  end
end
