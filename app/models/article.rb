#   Schema
# ==========
# 	table: articles
#
# 	article_id	:integer		not null, primary key
# 	title 			:string
# 	content 		:text
# 	user_id			:integer
# 	instance_id	:integer		not null, index
# 	created_at	:datetime		not null
# 	updated_at	:datetime		not null
#
# TODO: index for user_id?
# TODO: user_id, title -> not_null?

class Article < ActiveRecord::Base
	attr_accessible :content, :title

	belongs_to :user
	belongs_to :instance
	has_many :comments
end
