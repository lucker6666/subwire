class UsersController < ApplicationController
	before_filter :authenticate_user!
	before_filter :choose_instance!, :check_permissions, :except => [:finish, :finish_save]
	before_filter :restricted_to_superadmin, :only => [:index]
	skip_filter :finish_invitation, :only => [:finish, :finish_save]

	# TODO actions: update

	# GET /users
	def index
		@users = User.where(:is_deleted => false, :invitation_pending => false)
	end

	# GET /users/1
	def show
		@user = User.find(params[:id])
		@assignedCount = Relationship.where(:user_id => @user.id).length
		@adminCount = Relationship.where(:user_id => @user.id, :admin => true).length
		@articlesCount = Article.where(:user_id => @user.id).length
		@commentsCount = Comment.where(:user_id => @user.id).length
	end

	# GET /users/edit/1
	def edit
		#Man darf nur sich selber bearbeiten, es sei denn man ist super admin
		if current_user == @user || has_superadmin_privileges?
			@user = User.find(params[:id])
		else
			@user = current_user
		end

		@relationships = Relationship.where(:user_id =>@user.id)
	end

	# PUT /users/1
	def update
		@user = User.find(params[:id])
		@relationships = Relationship.where(:user_id =>@user.id)

		#Delete the email param
		params[:user].delete :email

		# Make sure the user tries to edit himself or the user is superadmin
		if current_user == @user || has_superadmin_privileges?
				if params[:user][:password].empty?
					params[:user].delete :password
					params[:user].delete :password_confirmation
				end

				#Relationships
				@relationships.each do |relationship|
					relationship.mail_notification = params['rel'+relationship.id.to_s]
					relationship.save
				end

				#Gravatar
				if(!@user.gravatar && params[:gravatar])
					@mail = @user.email
					@mail.strip!
					@user.gravatar = Digest::MD5.hexdigest(@mail.downcase)
					@user.save
				elsif (!params[:gravatar] && @user.gravatar)
					@user.gravatar = nil
					@user.save
				end

				if @user.update_attributes(params[:user])
					if has_superadmin_privileges?
						@user.is_admin = params[:is_admin]
						@user.save
					end

					if @user.id == current_user.id
						sign_in(@user, :bypass => true)
					end

					feedback t('users.updated')
					redirect_to user_path(@user)
				else
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

			#Check Instances from the User
			@ownInstances = Relationship.where(:user_id => @user.id, :admin => true)
			@ownInstances.each do |o|
				@userInInstance = Relationship.find_all_users_by_instance(o)

				if(@userInInstance.length > 1)
					#Another Admin in this Instance?
					if(@userInInstance.where(:is_admin => true).length < 2)
						feedback "You have an Instance with no other Admin!"
						redirect_to :back
					end
				else
					#Delete the Instance
					@instance = Instance.find(o.instance_id)
					@instance.destroy
				end
			end


			#Delete Notifications: useless
			@notifications = Notification.find_all_by_user_id(@user.id)
			@notifications.each do |n|
				n.destroy
			end

			#Delete all relationships
			@relationships = Relationship.where(:user_id => @user.id)
			@relationships.each do |r|
				r.destroy
			end

			#Destry the user not really, set only a flag
			@user.is_deleted = true
			@user.save

			# End session
			if @user == current_user
				sign_out(current_user)
			end

			feedback t('users.destroyed')
		end

		redirect_to :back
	end

	def finish
		if current_user.invitation_pending
			@user = User.find(current_user.id)
			@user.name = ""
			render :finish, :layout => "login"
		else
			redirect_to "/"
		end
	end

	def finish_save
		user = current_user

		if user.update_attributes(params[:user])
			user.invitation_pending = false
			user.save

			feedback t('users.invitation_finished')
			redirect_to "/"
		else
			errors_to_feedback user
			render :finish, :layout => "login"
		end
	end
end
