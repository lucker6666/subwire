class InstancesController < ApplicationController
	before_filter :authenticate_user!

	# GET /instance
	# GET /instance.json
	def index
		@instances = Instance.find(
			:all,
			:joins => :relationships,
			:conditions => { "relationships.user_id" => current_user.id }
		)

		@adminCount = Instance.find_all_where_user_is_admin(current_user).length

		respond_to do |format|
			format.html { render 'index', layout: 'login' } # home/index.html.erb
    end
	end

	# GET /instances/1
	def show
		set_current_instance Instance.find(params[:id])

		redirect_to articles_path
	end
end