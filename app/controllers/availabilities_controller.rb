class AvailabilitiesController < ApplicationController
  # POST /availabilities/set
  def set
    paramSet = {
      date: params[:date],
      value: params[:value]
    }

    availability = Availability.where(
      user_id: current_user.id,
      channel_id: current_channel.id,
      date: params[:date]
    ).first

    if availability.nil?
      availability = Availability.new(paramSet)
      availability.user = current_user
      availability.channel = current_channel
      availability.save
    else
      availability.update_attributes(paramSet)
    end

    head :no_content
  end
end
