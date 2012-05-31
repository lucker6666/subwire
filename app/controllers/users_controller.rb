class UsersController < ApplicationController
	before_filter :authenticate_user!, :choose_instance!, :check_permissions
	before_filter :check_admin, :except => [:edit, :update, :show]

	# GET /users
	def index
		@users = Relationship.find_all_users_by_instance(current_instance)
	end

	# GET /users/1
	def show
		@user = User.find(params[:id])
	end

	# GET /users/add
	def add
		render action: "new"
	end

	# POST /users/add
	def add2
		# Check wether this users already exists
		user = User.find(params[:email]).first

		if user.any
			# Check wether user is already associated with this instance
			if (Relationship.where(:instance_id => current_instance.id, :user_id => user.id))
				# User is already associated with this instance, do nothing but notify the user
				notify t("users.already_added")
				redirect_to :back
			else
				# User is not associated, create a Relationship
				Relationship.create(
					:instance => current_instance,
					:user => user,
					:admin => current_user.is_admin_of_instance?(current_instance) && params[:is_admin_of_instance]
				)

				notify t("users.added")
				redirect_to user_path(user)
			end
		else
			# User doesn't already exist, create one
			User.create(
				:email => params[:email]
			)

			# TODO Send E-Mail with invitation link to user

			notify t("users.added")
			redirect_to user_path(user)
		end
	end

	# GET /users/1/edit
	def edit
		if current_user.is_admin?
			@user = User.find(params[:id])
		else
			@user = current_user
		end

		@is_admin_of_instance = Relationship.is_user_admin_of_instance?(@user, current_instance)
	end

	# PUT /users/1
	def update
		if current_user.is_admin?
			@user = User.find(params[:id])
		else
			@user = current_user
		end

		if params[:user][:password].empty?
			params[:user].delete :password
		end

		if current_user.is_admin_of_instance?(current_instance)
			rel = Relationship.where(
				:instance_id => current_instance.id,
				:user_id => @user.id
			).first

			if params[:user][:is_admin_of_instance]
				rel.admin = true
			else
				rel.admin = false
			end

			rel.save
		end

		params[:user].delete :is_admin_of_instance

		if @user.update_attributes(params[:user])
			notify t('users.updated')
			redirect_to @user
		else
			notify t('users.not_updated')
			render action: "edit"
		end
	end

	# DELETE /users/1
	def destroy
		@user = User.find(params[:id])

		@notifications = Notification.where(
			:user_id => @user.id,
			:instance_id => current_instance
		)

		@notifications.each do |n|
			n.destroy
		end

		@relationship = Relationship.where(
			:user_id => @user.id,
			:instance_id => current_instance.id
		)

		@relationship.destroy

		notify t('users.removed')

		redirect_to users_url
	end
end
