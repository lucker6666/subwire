class ChannelsController < ApplicationController
  before_filter :load_channel, only: [:show]
  before_filter :load_channels, only: [:index]

  def index
    authorize! :read, Channel
  end

  def show
  end

  private

    def load_channel
      @channel = Channel.find_by_permalink(params[:id])
      authorize! :read, @channel
    end
end