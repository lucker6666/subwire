#   Schema
# ==========
# 	table: availabilities
#
# 	availability_id		:integer		not null, primary key
# 	user_id						:integer		index
# 	instance_id				:integer		not null, index
# 	value							:boolean
#  	created_at				:datetime
# 	updated_at				:datetime

class Availability < ActiveRecord::Base
	attr_accessible :date, :value

	belongs_to :user
	belongs_to :instance
end
