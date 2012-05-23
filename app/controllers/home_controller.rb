class HomeController < ApplicationController
	before_filter :authenticate_user!

	# GET /
	def index
		@instances = Instance.find_all_by_user(current_user)

		if @instances.length > 1
			redirect_to instances_path
		else
			set_current_instance @instances.first
			redirect_to articles_path
		end
	end
end