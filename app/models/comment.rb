class Comment < ActiveRecord::Base
	attr_accessible :content, :user, :instance

	belongs_to :article
	belongs_to :user
end
