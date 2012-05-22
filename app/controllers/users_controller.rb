class UsersController < ApplicationController
	before_filter :authenticate_user!
	before_filter :check_admin, :except => [:edit, :update, :show]

	# GET /users
	# GET /users.json
	def index
		@users = User.find_all_by_instance(current_instance)

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @users }
		end
	end

	# GET /users/1
	# GET /users/1.json
	def show
		@user = User.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @user }
		end
	end

	# GET /users/new
	# GET /users/new.json
	def new
		@user = User.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @user }
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

	# POST /users
	# POST /users.json
	def create
		@user = User.new(params[:user])
		@user.instance = current_instance

		respond_to do |format|
			if @user.save
				format.html { redirect_to @user, notice: 'User was successfully created.' }
				format.json { render json: @user, status: :created, location: @user }
			else
				format.html { render action: "new" }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /users/1
	# PUT /users/1.json
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

		respond_to do |format|
			if @user.update_attributes(params[:user])
				format.html { redirect_to @user, notice: 'User was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /users/1
	# DELETE /users/1.json
	# TODO Multiinstance: how is the behaviour here if a user is deleted?
	def destroy
		@user = User.find(params[:id])

		@notifications = Notification.find_all_by_user_id(@user.id)
		@notifications.each do |n|
			n.destroy
		end

		@user.destroy

		respond_to do |format|
			format.html { redirect_to users_url }
			format.json { head :no_content }
		end
	end
end
