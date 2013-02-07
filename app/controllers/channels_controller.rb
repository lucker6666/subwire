class ChannelsController < ApplicationController
  before_filter :load_channel, only: [:show]
  before_filter :load_channels, only: [:index]

  def index
    authorize! :read, Channel

    # TODO move that to a helper or model
      # Required to check if user has reached the limit of instances
      @adminCount = Channel.find_all_where_user_is_admin(current_user).length
  end

  def show
  end

  private

    def load_channel
      @channel = Channel.find_by_permalink(params[:id])
      authorize! :read, @channel
    end
end