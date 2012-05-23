class Instance < ActiveRecord::Base
	attr_accessible :name, :defaultLanguage, :advertising, :planningTool

	has_many :articles
	has_many :availabilities
	has_many :notifications
	has_many :relationships
	has_many :users, :through => :relationships

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
