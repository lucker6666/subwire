class MessagesController < ApplicationController
  before_filter :load_channel

  def index
     if params[:query].present?
      @messages = Message.search(params[:query],
        load: true,
        page: params[:page],
        per_page: 10,
        order: "created_at DESC",
        conditions: { channel_id: @channel.id }
      )
    else
      @messages = Message.find_all_by_channel_id_and_page(@channel.id, params[:page])
    end
  end
end
