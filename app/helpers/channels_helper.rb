module ChannelsHelper
  def channels
    Channel.find_all_by_user(current_user)
  end
end