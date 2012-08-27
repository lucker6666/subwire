require 'spec_helper'

describe ArticlesController do
	describe "GET 'index'" do
		# Following doesn't work here
		context "and user is not assigned to the chosen instance" do
			context "but is superadmin" do
		  	it "should render articles index of that instance" do
			  	# TODO
			  end
			end

			context "and no superadmin" do
				it "should redirect back to the instance chooser" do
		  		@rel1 = FactoryGirl.create(:user1_with_instance)

			    # Then choose a instance to which the current user is not assigned to
		    	set_current_instance @rel1.instance

			    # Then request the startpage
			    get :index
			    response.should redirect_to(instances_url)
			    current_instance.should be_nil
			  end
			end
		end
	end
end
