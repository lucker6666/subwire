#   Schema
# ==========
# 	table: availabilities
#
# 	availability_id		:integer		not null, primary key
# 	user_id						:integer		index
# 	instance_id				:integer		not null, index
# 	value							:boolean
# 	date							:date
#  	created_at				:datetime
# 	updated_at				:datetime

class Availability < ActiveRecord::Base
	### Attributes
	attr_accessible :date, :value

	### Associations
	belongs_to :user
	belongs_to :instance

	### Validations
	# Make sure, date is not empty
	validates :date, :presence => true
end
