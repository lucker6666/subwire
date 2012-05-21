class Availability < ActiveRecord::Base
	attr_accessible :date, :value, :user, :instance

	belongs_to :user
	belongs_to :instance
end
