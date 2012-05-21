class Instance < ActiveRecord::Base
	attr_accessible :name, :defaultLanguage, :advertising, :planningTool

	has_many :articles
	has_many :availabilities
	has_many :notifications
	has_many :relationships
	has_many :users, :through => :relationships
end
