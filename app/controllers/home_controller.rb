class HomeController < ApplicationController
	# GET /
	def index
		if current_user
			if current_instance
				redirect_to articles_path
			else
				redirect_to instances_path
			end
		else
			flash.keep
			redirect_to "/users/sign_in"
		end
	end

	def inactive
		flash.keep
		redirect_to "/"
	end

	def virgin
		render "virgin", :layout => "empty"
	end
end