class AvailabilitiesController < ApplicationController
	# POST /availabilities
	def set
		paramSet = {
			:date => params[:date],
			:value => params[:value],
			:user => current_user
		}

		availability = Availability.where("user_id = ? and date = ?",
			current_user, params[:date]).first

		if availability.nil?
			availability.save
			availability = Availability.new(paramSet)
		else
			availability.update_attributes(paramSet)
		end

		head :no_content
	end
end
