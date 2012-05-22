class HomeController < ApplicationController
	before_filter :authenticate_user!

	# GET /
	def index
		@instances = Instance.find(
			:all,
			:joins => :relationships,
			:conditions => { "relationships.user_id" => current_user.id }
		)

		if @instances.length > 1
			respond_to do |format|
				format.html # home/index.html.erb
	    end
		else
			set_current_instance @instances.first
			redirect_to articles_path
		end
	end
end