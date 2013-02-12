class CommentsController < ApplicationController
  before_filter :load_message, only: [:load_all]

  def load_all
    render :partial => 'shared/comments', :locals => {
      comments: @message.newest_comments,
      message: @message
    }
  end


  private

    def load_message
      @message = Message.find(params[:message_id])
      authorize! :read, @message
    end
end
