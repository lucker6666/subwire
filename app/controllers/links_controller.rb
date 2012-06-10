class LinksController < ApplicationController
	# User have to be logged in, choosed an instance and have to be allowed to see that instance
	# and have to be at least admin of that instance
	before_filter :authenticate_user!, :choose_instance!, :check_permissions, :restricted_to_admin

	# GET /links
	def index
		@links = Link.find_all_by_instance_id(current_instance.id)
	end

	# GET /links/1
	def show
		@link = Link.find(params[:id])
	end

	# GET /links/new
	def new
		@link = Link.new
	end

	# GET /links/1/edit
	def edit
		@link = Link.find(params[:id])
	end

	# POST /links
	def create
		@link = Link.new(params[:link])
		@link.instance = current_instance

		if @link.save
			feedback t('links.created')
			redirect_to links_path
		else
			feedback t('links.not_created')
			render action: "new"
		end
	end

	# PUT /links/1
	def update
		@link = Link.find(params[:id])

		if @link.update_attributes(params[:link])
			feedback t('users.updated')
			redirect_to link_path(@link)
		else
			render action: "edit"
		end
	end

	# DELETE /links/1
	def destroy
		@link = Link.find(params[:id])
		@link.destroy

		redirect_to links_url
	end
end
