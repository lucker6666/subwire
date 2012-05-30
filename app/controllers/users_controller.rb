class UsersController < ApplicationController
	before_filter :authenticate_user!, :choose_instance!
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
					:admin => current_user.is_admin? && params[:admin]
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

		# make sure that there is no is_admin-value while user is not a admin
		if !params[:user][:is_admin].nil? && !current_user.is_admin
			params[:user][:is_admin] = false
		end

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
