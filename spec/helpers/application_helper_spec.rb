require 'spec_helper'

describe ApplicationHelper do
  describe "#login_background" do
    it "should return a random background hash" do
      Subwire::Application.config.backgrounds.should include(login_background)
    end
  end
end