#   Schema
# ==========
# 	table: links
#
# 	link_id				:integer		not null, primary key
# 	instance_id		:integer		not null, index
# 	name					:string
# 	href					:string
# 	icon					:string
# 	created_at		:datetime		not null
# 	updated_at		:datetime		not null

class Link < ActiveRecord::Base
	attr_accessible :href, :name, :icon

	belongs_to :instance
end
