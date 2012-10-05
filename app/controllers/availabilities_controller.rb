class AvailabilitiesController < ApplicationController
  # POST /availabilities/set
  def set
    if current_user && current_channel && (current_user.is_admin? || current_rs)
      paramSet = {
        date: params[:date],
        value: params[:value]
      }

      availability = current_user.availabilities.where(
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
    end

    head :no_content
  end
end
