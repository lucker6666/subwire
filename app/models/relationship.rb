class Relationship < ActiveRecord::Base
	attr_accessible :admin

	belongs_to :instance
	belongs_to :user
end
