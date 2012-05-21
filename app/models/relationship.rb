class Relationship < ActiveRecord::Base
	attr_accessible :admin, :instance, :user

	belongs_to :instance
	belongs_to :user
end
