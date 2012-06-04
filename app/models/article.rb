class Article < ActiveRecord::Base
	attr_accessible :content, :title, :user, :instance

	belongs_to :user
	belongs_to :instance
	has_many :comments
end
