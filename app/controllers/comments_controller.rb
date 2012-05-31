class CommentsController < ApplicationController
	# User have to be logged in, choosed an instance and have to be allowed to see that instance
	before_filter :authenticate_user!, :choose_instance!, :check_permissions

	# POST /comments
	def create
		@article = Article.find(params[:article_id])
		@comment = @article.comments.build(params[:comment])
		@comment.user = current_user

		# Notify all users
		if @comment.save
			Notification.notify_all_users({
				:notification_type => "new_comment",
				:message => "<strong>"+t("comments.new_notification", user: @comment.user.name)+":</strong> <br />#{@article.title}",
				:href => article_path(@article)
			})

			feedback t("comments.new_success")
		else
			errors_to_feedback @comment
		end

		redirect_to article_path(@article)
	end

	# PUT /comments/1
	# PUT /comments/1.json
	def update
		@comment = Comment.find(params[:id])

		# Make sure the user is the author of the comment or user is admin
		if current_user == @comment.user || has_admin_privileges?
			respond_to do |format|
				if @comment.update_attributes(params[:comment])
					format.html { redirect_to :back, notice: t("comments.update_success") }
					format.json { head :no_content }
				else
					format.html { render action: "edit" }
					format.json { render json: @comment.errors, status: :unprocessable_entity }
				end
			end
		else
			redirect_to :back
		end
	end

	# DELETE /comments/1
	def destroy
		@comment = Comment.find(params[:id])

		# Make sure the user is the author of the comment or user is admin
		if current_user == @comment.user || has_admin_privileges?
			@notifications = Notification.find_all_by_href(article_path(@comment.article))
			@notifications.each do |n|
				n.destroy
			end

			@comment.destroy

			feedback t('comments.destroyed')
		end

		redirect_to :back
	end
end
