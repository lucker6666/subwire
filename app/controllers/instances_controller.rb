class InstancesController < ApplicationController
	before_filter :authenticate_user!

	# GET /instance
	def index
		@instances = Instance.find(
			:all,
			:joins => :relationships,
			:conditions => { "relationships.user_id" => current_user.id }
		)

		@adminCount = Instance.find_all_where_user_is_admin(current_user).length

		render 'index', layout: 'login'
	end

	# GET /instances/1
	def show
		set_current_instance Instance.find(params[:id])

		redirect_to articles_path
	end

	# GET /instances/new
	def new
		if Instance.find_all_where_user_is_admin(current_user).length > 4
			notify t('instances.hit_limit')
			redirect_to :back
		else
			@instance = Instance.new

			@containerClass = "newInstance"

			render 'new', layout: 'login'
		end
	end

	# GET /instances/1/edit
	def edit
		if current_user.is_admin? or
			Relationship.is_user_admin_of_instance?(current_user, current_instance)

			@instance = Instance.find(params[:id])
		else
			notify "Access denied!"
			redirect_to :back
		end
	end

	# POST /instances
	def create
		if current_user.is_admin? or
			Relationship.is_user_admin_of_instance?(current_user, current_instance)

			@instance = Instance.new(params[:instance])

			if @instance.save
				Relationship.create(
					:user => current_user,
					:instance => @instance,
					:admin => true
				)

				notify t('instances.created')
				redirect_to instance_path(@instance)
			else
				notify t('instances.not_created')
				render action: "new"
			end
		end
	end

	# PUT /instances/1
	def update
		if current_user.is_admin? or
			Relationship.is_user_admin_of_instance?(current_user, current_instance)

			@instance = Instance.find(params[:id])
		else
			notify "Access denied!"
			redirect_to :back
		end

		# make sure that there is no advertising-value while user is not a admin
		if !params[:instance][:advertising].nil? && !current_user.is_admin
			params[:instance][:advertising] = true
		end

		if @instance.update_attributes(params[:instance])
			notify t('instances.updated')
			redirect_to instance_path(@instance)
		else
			notify t('instances.not_updated')
			render action: "edit"
		end
	end

	# DELETE /instances/1
	def destroy
		if current_user.is_admin? or
			Relationship.is_user_admin_of_instance?(current_user, current_instance)

			@instance = Instance.find(params[:id])

			@notifications = Notification.find_all_by_instance_id(@instance.id)
			@notifications.each do |n|
				n.destroy
			end

			@instance.destroy

			redirect_to instances_path
		end
	end

	# GET /instances/unset
	def unset
		set_current_instance nil
		redirect_to "/"
	end
end