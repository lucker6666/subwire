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
			redirect_to "/users/sign_in"
		end
	end

	def inactive
		#feedback t("users.inactive")
		feedback "test"
		redirect_to "/", notice: flash
	end
end