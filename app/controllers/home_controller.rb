class HomeController < ApplicationController
	# User have to be logged in
	before_filter :authenticate_user!

	# GET /
	def index
		if current_instance
			redirect_to articles_path
		else
			redirect_to instances_path
		end
	end
end