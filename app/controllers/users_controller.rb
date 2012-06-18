class UsersController < ApplicationController
	before_filter :authenticate_user!, :choose_instance!, :check_permissions
	before_filter :restricted_to_superadmin, :only => [:index]

	# TODO actions: update

	# GET /users
	def index
		@users = User.all
	end

	# GET /users/1
	def show
		@user = User.find(params[:id])
	end

	# GET /users/edit/1
	def edit
		@user = User.find(params[:id])
	end

	# PUT /users/1
	def update
		@user = User.find(params[:id])
		# Make sure the user tries to edit himself or the user is superadmin
		if current_user == @user || has_superadmin_privileges?
				if params[:user][:password].empty?
					params[:user].delete :password
				end

				if @user.update_attributes(params[:user])
					if has_superadmin_privileges?
						@user.is_admin = params[:user][:admin]
					end

					feedback t('users.updated')
					redirect_to user_path(@user)
				else
					errors_to_feedback @user
					render action: "edit"
				end
		else
			redirect_to :back
		end
	end

	# DELETE /users/1
	def destroy
		@user = User.find(params[:id])

		# Make sure the user tries to delete himself or the user is superadmin
		if current_user == @user || has_superadmin_privileges?
			@notifications = Notification.find_all_by_user_id(@user.id)
			@notifications.each do |n|
				n.destroy
			end

			@user.destroy

			feedback t('users.destroyed')
		end

		redirect_to :back
	end
end
