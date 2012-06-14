class AvailabilitiesController < ApplicationController
	# POST /availabilities/set
	def set
		paramSet = {
			:date => params[:date],
			:value => params[:value]
		}

		availability = Availability.where(
			:user_id => current_user.id,
			:instance_id => current_instance.id,
			:date => params[:date]
		).first

		if availability.nil?
			availability = Availability.create(paramSet),
			availability.user = current_user
			availability.instance = current_instance
		else
			availability.update_attributes(paramSet)
		end

		head :no_content
	end
end
