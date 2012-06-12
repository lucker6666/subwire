class RelationshipsController < ApplicationController
	before_filter :authenticate_user!, :choose_instance!, :check_permissions
	before_filter :restricted_to_admin, :except => [:destroy]

	# TODO actions: create, update

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
		@relationship = Relationship.new(params[:relationship])
		@relationship.user = User.find(params[:relationship][:user])
		@relationship.instance = current_instance

		if @relationship.save
			feedback t('relationships.created')
			redirect_to relationships_path(@article)
		else
			feedback t('relationships.not_created')
			render action: "new"
		end
	end

	# PUT /relationships/1
	def update
		@relationship = Relationship.find(params[:id])

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
