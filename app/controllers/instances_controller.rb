class InstancesController < ApplicationController
	before_filter :authenticate_user!

	# GET /instance
	# GET /instance.json
	def index
		@instances = Instance.find(
			:all,
			:joins => :relationships,
			:conditions => { "relationships.user_id" => current_user.id }
		)

		@adminCount = Instance.find_all_where_user_is_admin(current_user).length

		respond_to do |format|
			format.html { render 'index', layout: 'login' } # home/index.html.erb
    end
	end

	# GET /instances/1
	def show
		set_current_instance Instance.find(params[:id])

		redirect_to articles_path
	end

	# GET /instances/new
	# GET /instances/new.json
	def new
		if Instance.find_all_where_user_is_admin(current_user).length > 4
			notify t('instances.hit_limit')
			redirect_to :back
		else
			@instance = Instance.new

			@containerClass = "newInstance"

			respond_to do |format|
				format.html { render 'new', layout: 'login' } # new.html.erb
				format.json { render json: @instance }
			end
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
	# POST /instances.json
	def create
		if current_user.is_admin? or
			Relationship.is_user_admin_of_instance?(current_user, current_instance)

			@instance = Instance.new(params[:instance])
			success = @instance.save

			if success
				Relationship.create(
					:user => current_user,
					:instance => @instance,
					:admin => true
				)
			end

			respond_to do |format|
				if success
					format.html { redirect_to @instance, notice: 'Instance was successfully created.' }
					format.json { render json: @instance, status: :created, location: @instance }
				else
					format.html { render action: "new" }
					format.json { render json: @instance.errors, status: :unprocessable_entity }
				end
			end
		end
	end

	# PUT /instances/1
	# PUT /instances/1.json
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

		respond_to do |format|
			if @instance.update_attributes(params[:instance])
				format.html { redirect_to @instance, notice: 'Instance was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @instance.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /instances/1
	# DELETE /instances/1.json
	def destroy
		if current_user.is_admin? or
			Relationship.is_user_admin_of_instance?(current_user, current_instance)

			@instance = Instance.find(params[:id])

			@notifications = Notification.find_all_by_instance_id(@instance.id)
			@notifications.each do |n|
				n.destroy
			end

			@instance.destroy

			respond_to do |format|
				format.html { redirect_to instances_url }
				format.json { head :no_content }
			end
		end
	end

	def unset
		set_current_instance nil
		redirect_to "/"
	end
end