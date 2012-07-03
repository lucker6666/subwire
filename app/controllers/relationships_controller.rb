class RelationshipsController < ApplicationController
	before_filter :authenticate_user!, :choose_instance!, :check_permissions
	before_filter :restricted_to_admin, :except => [:destroy]

	# GET /relationships
	def index
		@relationships = Relationship.find_all_by_instance_id(current_instance.id)
	end

	# GET /relationships/new
	def new
		@relationship = Relationship.new
	end

	# GET /relationships/1/edit
	def edit
		@relationship = Relationship.find(params[:id])
	end

	# POST /relationships
	def create
		@relationship = Relationship.new

		user = User.find_by_email(params[:relationship][:email])

		unless user
			# TODO create new user!
			feedback "TODO ! user doesn't exist!" # TODO translate
			render action: "new"
		else
			@relationship.user = user
			@relationship.instance = current_instance

			if has_admin_privileges?
				@relationship.admin = params[:relationship][:admin]
			end

			# TODO: Create User and send email, if doesn't exist

			@relationship.instance = current_instance

			if @relationship.save
				Notification.notify_all_users({
					:notification_type => "new_user",
					:message => "<strong>"+t("relationships.new_user", user: user.name) +
						":</strong> <br />",
					:href => user_path(user)
				}, current_instance, current_user, :except => [user])

				feedback t('relationships.created')
				redirect_to relationships_path(@article)
			else
				feedback t('relationships.not_created')
				render action: "new"
			end
		end
	end

	# PUT /relationships/1
	def update
		@relationship = Relationship.find(params[:id])

		if has_admin_privileges?
			@relationship.admin = params[:relationship][:admin]
		end

		params[:relationship].delete :admin

		if current_user == @relationship.user || has_admin_privileges?
			if @relationship.update_attributes(params[:relationship])
				feedback t('relationships.updated')
				redirect_to relationships_path
			else
				render action: "edit"
			end
		else
			redirect_to :back
		end
	end

	# DELETE /relationships/1
	def destroy
		@relationship = Relationship.find(params[:id])

		if current_user == @relationship.user || has_admin_privileges?
			@relationship.destroy

			feedback t('relationships.destroyed')

			if current_user == @relationship.user
				redirect_to "/"
			else
				redirect_to relationships_path
			end
		else
			redirect_to :back
		end
	end
end
