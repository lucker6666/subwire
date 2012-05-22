class AvailabilitiesController < ApplicationController
	# POST /availabilities
	def set
		paramSet = {
			:date => params[:date],
			:value => params[:value],
			:user => current_user,
			:instance => current_instance
		}

		availability = Availability.where(
			:user_id => current_user.id,
			:instance_id => current_instance.id,
			:date => params[:date]
		).first

		if availability.nil?
			availability.save
			availability = Availability.new(paramSet)
		else
			availability.update_attributes(paramSet)
		end

		head :no_content
	end
end
