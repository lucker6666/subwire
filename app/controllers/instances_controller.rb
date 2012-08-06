class InstancesController < ApplicationController
	# User have to be logged in
	before_filter :authenticate_user!
	before_filter :restricted_to_superadmin, :only => [:all]

	# GET /instance
	def index
		@instances = Instance.find(
			:all,
			:joins => :relationships,
			:conditions => { "relationships.user_id" => current_user.id }
		)

		# Required to check if user has reached the limit of instances
		@adminCount = Instance.find_all_where_user_is_admin(current_user).length

		@notificationCount = 0
		@instances.each do |instance|
			@notificationCount += instance.notification_count(current_user)
		end

		render 'index', layout: 'login'
	end

	# GET /instances/1
	def show
		set_current_instance Instance.find(params[:id])

		redirect_to articles_path
	end

	# GET /instances/new
	def new
		if !has_superadmin_privileges? && Instance.find_all_where_user_is_admin(current_user).length > 4
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
			if has_superadmin_privileges?
				advertising = params[:instance][:advertising]
			else
				advertising = true
			end

			params[:instance].delete :advertising

			@instance = Instance.new(params[:instance])
			@instance.advertising = advertising

			if @instance.save
				rel = Relationship.new
				rel.user = current_user
				rel.instance = @instance
				rel.admin = true
				rel.save

				article = Article.new
				article.user = current_user
				article.instance = @instance
				article.title = t('articles.standard_title', :locale => @instance.defaultLanguage)
				article.content = t('articles.standard_content', :locale => @instance.defaultLanguage)
				article.save

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

		# Make sure that advertising is not set to false while user is not a superadmin
		@instance.advertising = params[:instance][:advertising]
		if !params[:instance][:advertising].nil? && !has_superadmin_privileges?
			@instance.advertising = true
		end

		params[:instance].delete :advertising

		if @instance.update_attributes(params[:instance])
			feedback t('instances.updated')
		else
			feedback t('instances.not_updated')
			errors_to_feedback(@instance)
		end

		render action: "edit", layout: 'login'
	end

	# DELETE /instances/1
	def destroy
		@instance = Instance.find(params[:id])

		if has_superadmin_privileges? || Relationship.is_user_admin_of_instance?(current_user, @instance)
			@notifications = Notification.find_all_by_instance_id(@instance.id)
			@notifications.each do |n|
				n.destroy
			end

			relationships = Relationship.find_all_by_instance_id(@instance.id)
			relationships.each do |r|
				r.destroy
			end

			articles = Article.find_all_by_instance_id(@instance.id)
			articles.each do |a|
				a.destroy
			end

			@instance.destroy

			feedback t('instances.destroyed')

			set_current_instance nil

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

	# GET /instances/all
	def all
		@instances = Instance.all
	end
end