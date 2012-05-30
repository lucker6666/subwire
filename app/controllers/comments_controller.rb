class CommentsController < ApplicationController
	before_filter :authenticate_user!, :choose_instance!

	# POST /comments
	# POST /comments.json
	def create
		@article = Article.find(params[:article_id])
		@comment = @article.comments.build(params[:comment])
		@comment.user = current_user

		success = @comment.save

		# Notify all users
		if success
			notify_all_users({
				:notification_type => "new_comment",
				:message => "<strong>"+t("comments.new_notification", user: @comment.user.name)+":</strong> <br />#{@article.title}",
				:href => article_path(@article)
			})
		end

		if success
			notify t("comments.new_success")
		else
			errors_to_notfications @comment
		end

		redirect_to article_path(@article)
	end

	# PUT /comments/1
	# PUT /comments/1.json
	def update
		@comment = Comment.find(params[:id])

		if current_user == @comment.user || current_user.is_admin?
			respond_to do |format|
				if @comment.update_attributes(params[:comment])
					format.html { redirect_to :back, notice: 'Comment was successfully updated.' }
					format.json { head :no_content }
					notify t("comments.update_success")
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
	# DELETE /comments/1.json
	def destroy
		@comment = Comment.find(params[:id])

		if current_user == @comment.user || current_user.is_admin?
			@notifications = Notification.find_all_by_href(article_path(@comment.article))
			@notifications.each do |n|
				n.destroy
			end

			@comment.destroy
		end

		redirect_to :back
	end
end
