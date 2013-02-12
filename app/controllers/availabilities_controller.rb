class AvailabilitiesController < ApplicationController
  before_filter :load_channel


  # POST /channels/:id/availabilities/set
  def set
    authorize! [:create, :update], , Availability

    paramSet = {
      date: params[:date],
      value: params[:value]
    }

    # Find regarding availability
    availability = current_user.availabilities.where(
      channel_id: @current_channel.id,
      date: params[:date]
    ).first

    # No availability found? Create a new one
    if availability.nil?
      availability = Availability.new(paramSet)
      availability.user = current_user
      availability.channel = @current_channel
      availability.save
    else
      # Otherwise change the value of that availability
      availability.update_attributes(paramSet)
    end

    head :no_content
  end
end