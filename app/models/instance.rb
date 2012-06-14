#   Schema
# ==========
# 	table: instances
#
# 	instance_id				:integer		not null, primary key
# 	name							:string			not null
# 	defaultLanguage 	:string			not null, default => "en"
# 	advertising				:boolean		not null, default => true
# 	planningTool			:boolean		not null, default => false
# 	created_at				:datetime		not null
# 	updated_at				:datetime		not null

class Instance < ActiveRecord::Base
	attr_accessible :name, :defaultLanguage, :planningTool

	has_many :articles
	has_many :availabilities
	has_many :notifications
	has_many :relationships
	has_many :users, :through => :relationships

  validates :name, :length => {
  	:maximum => 20
  }

	def self.find_all_where_user_is_admin(user)
		find(
			:all,
			:joins => :relationships,
			:conditions => {
				"relationships.user_id" => user.id,
				"relationships.admin" => true
			}
		)
	end

	def self.find_all_by_user(user)
		find(
			:all,
			:joins => :relationships,
			:conditions => { "relationships.user_id" => user.id }
		)
	end
end
