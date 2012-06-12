class InstancesController < ApplicationController
	# User have to be logged in
	before_filter :authenticate_user!

	# User must be allowed to see the instance to edit and update
	before_filter :check_permissions, :only => [:show]

	# GET /instance
	def index
		@instances = Instance.find(
			:all,
			:joins => :relationships,
			:conditions => { "relationships.user_id" => current_user.id }
		)

		# Required to check if user has reached the limit of instances
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
			feedback t('instances.hit_limit')
			redirect_to instances_path
		else
			@instance = Instance.new

			render 'new', layout: 'login'
		end
	end

	# GET /instances/1/edit
	def edit
		@instance = Instance.find(params[:id])

		unless has_superadmin_privileges? || Relationship.is_user_admin_of_instance?(current_user, @instance)
			feedback "Access denied!"
			redirect_to :back
		end

		render 'edit', layout: 'login'
	end

	# POST /instances
	def create
		if !has_superadmin_privileges? && Instance.find_all_where_user_is_admin(current_user).length > 4
			feedback t('instances.hit_limit')
			redirect_to :back
		else
			@instance = Instance.new(params[:instance])

			if @instance.save
				Relationship.create(
					:user => current_user,
					:instance => @instance,
					:admin => true
				)

				feedback t('instances.created')
				redirect_to instance_path(@instance)
			else
				feedback t('instances.not_created')
				errors_to_feedback(@instance)
				render action: "new", layout: 'login'
			end
		end
	end

	# PUT /instances/1
	def update
		@instance = Instance.find(params[:id])
		unless has_superadmin_privileges? || Relationship.is_user_admin_of_instance?(current_user, @instance)
			feedback "Access denied!"
			redirect_to :back
		end

		# Make sure that there is no advertising-value while user is not a admin
		if !params[:instance][:advertising].nil? && !has_superadmin_privileges?
			params[:instance][:advertising] = true
		end

		if @instance.update_attributes(params[:instance])
			feedback t('instances.updated')
			redirect_to instance_path(@instance)
		else
			feedback t('instances.not_updated')
			render action: "edit"
		end
	end

	# DELETE /instances/1
	def destroy
		@instance = Instance.find(params[:id])

		if has_superadmin_privileges? || Relationship.is_user_admin_of_instance?(current_user, @instance)
			@notifications = Notification.find_all_by_instance_id(@instance.id)
			@notifications.each do |n|
				n.destroy
			end

			@instance.destroy

			feedback t('instances.destroyed')

			redirect_to instances_path
		else
			feedback t('application.permission_denied')
			redirect_to instances_path
		end
	end

	# GET /instances/unset
	def unset
		set_current_instance nil
		redirect_to instances_path
	end
end