class ArticlesController < ApplicationController
	# User have to be logged in, choosed an instance and have to be allowed to see that instance
	before_filter :authenticate_user!, :choose_instance!, :check_permissions

	# GET /articles
	def index
		@articles = Article.paginate(
			:page => params[:page],
			:per_page => 5,
			:order => "created_at DESC",
			:conditions => { :instance_id => current_instance.id }
		)
  	end

	# GET /articles/1
	def show
		@article = Article.find(params[:id])

		@notifications = Notification.where(
			:user_id => current_user.id,
			:instance_id => current_instance.id
		)

		# Delete all notifications regarding that article
		unless @notifications.nil?
			@notifications.each do |notification|
				if notification.href == article_path(@article)
					notification.destroy
				end
			end
		end

		@notifications = Notification.find_all_by_user_id(current_user.id)
	end

	# GET /articles/new
	def new
		@article = Article.new
	end

	# GET /articles/1/edit
	def edit
		@article = Article.find(params[:id])
	end

	# POST /articles
	def create
		@article = Article.new(params[:article])
		@article.user = current_user
		@article.instance = current_instance

		# Notify all users
		if @article.save
			Notification.notify_all_users({
				:notification_type => "new_article",
				:message => "<strong>New article from #{@article.user.name}:</strong> <br />#{@article.title}",
				:href => article_path(@article)
			})

			feedback t('articles.created')
			redirect_to article_path(@article)
		else
			feedback t('articles.not_created')
			render action: "new"
		end
	end

	# PUT /articles/1
	def update
		@article = Article.find(params[:id])

		if current_user == @article.user || current_user.is_admin?
			if @article.update_attributes(params[:article])
				# Notify all users
				Notification.notify_all_users({
					:notification_type => "edit_article",
					:message => "<strong>Article edited from #{@article.user.name}:</strong> <br />#{@article.title}",
					:href => article_path(@article)
				})

				feedback t('articles.updated')
				redirect_to article_path(@article)
			else
				render action: "edit"
			end
		else
			redirect_to :back
		end
	end

	# DELETE /articles/1
	def destroy
		@article = Article.find(params[:id])

		if current_user == @article.user || current_user.is_admin?
			# Delete all notifications
			@notifications = Notification.where(
				:href => article_path(@article),
				:instance_id => current_instance.id
			)

			@notifications.each do |n|
				n.destroy
			end

			# Delete all comments
			@comments = Comment.find_all_by_article_id(@article.id)
			@comments.each do |c|
				c.destroy
			end

			@article.destroy

			feedback t('articles.destroyed')

			redirect_to articles_url
		else
			redirect_to :back
		end
	end
end
