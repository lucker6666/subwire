class Article < ActiveRecord::Base
	attr_accessible :content, :title, :user

	belongs_to :user
	has_many :comments
end
