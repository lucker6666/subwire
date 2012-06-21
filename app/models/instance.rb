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
	### Attributes
	attr_accessible :name, :defaultLanguage, :planningTool

	### Associations
	has_many :articles
	has_many :availabilities
	has_many :notifications
	has_many :relationships
	has_many :users, :through => :relationships

	### Validations
	# Make sure, name is not empty and maximum 30 chars length
	validates :name, :presence => true, :length => {
		:maximum => 30
	}

	validates :defaultLanguage, :inclusion => {
		:in => %w(en de)
	}


	### Methods

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

	def article_count
		Article.find_all_by_instance_id(id).length
	end

	def user_count
		Relationship.find_all_by_instance_id(id).length
	end

	def notification_count(user)
		Notification.where(
			:instance_id => id,
			:user_id => user.id
		).length
	end
end
