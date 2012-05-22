class ArticlesController < ApplicationController
	before_filter :authenticate_user!


	# GET /articles
	# GET /articles.json
	def index
		@articles = Article.paginate(
			:page => params[:page],
			:per_page => 5,
			:order => "created_at DESC",
			:conditions => { :instance_id => current_instance.id }
		)

		respond_to do |format|
			format.html # articles/index.html.erb
			format.json { render json: @articles }
    end
  end

	# GET /articles/1
	# GET /articles/1.json
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

		respond_to do |format|
			format.html # articles/show.html.erb
			format.json { render json: @article }
		end
	end

	# GET /articles/new
	# GET /articles/new.json
	def new
		@article = Article.new

		respond_to do |format|
			format.html # articles/new.html.erb
			format.json { render json: @article }
		end
	end

	# GET /articles/1/edit
	def edit
		@article = Article.find(params[:id])
	end

	# POST /articles
	# POST /articles.json
	def create
		@article = Article.new(params[:article])
		@article.user = current_user
		@article.instance = current_instance

		success = @article.save

		# Notify all users
		if success
			notify_all_users({
				:notification_type => "new_article",
				:message => "<strong>New article from #{@article.user.name}:</strong> <br />#{@article.title}",
				:href => article_path(@article)
			})
		end

		respond_to do |format|
			if success
				format.html { redirect_to @article, notice: 'Article was successfully created.' }
				format.json { render json: @article, status: :created, location: @article }
			else
				format.html { render action: "new" }
				format.json { render json: @article.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /articles/1
	# PUT /articles/1.json
	def update
		@article = Article.find(params[:id])

		if current_user == @article.user || current_user.is_admin?
			success = @article.update_attributes(params[:article])

			# Notify all users
			if success
				notify_all_users({
					:notification_type => "edit_article",
					:message => "<strong>Article edited from #{@article.user.name}:</strong> <br />#{@article.title}",
					:href => article_path(@article)
				})
			end

			respond_to do |format|
				if success
					format.html { redirect_to @article, notice: 'Article was successfully updated.' }
					format.json { head :no_content }
				else
					format.html { render action: "edit" }
					format.json { render json: @article.errors, status: :unprocessable_entity }
				end
			end
		else
			redirect_to :back
		end
	end

	# DELETE /articles/1
	# DELETE /articles/1.json
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

			respond_to do |format|
				format.html { redirect_to articles_url }
				format.json { head :no_content }
			end
		else
			redirect_to :back
		end
	end
end
