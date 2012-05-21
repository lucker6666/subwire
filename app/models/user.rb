class User < ActiveRecord::Base
	devise :database_authenticatable, :rememberable, :validatable

	attr_accessible :login, :is_admin, :name, :email, :password, :password_confirmation,
		:remember_me, :color, :last_seen, :relationship

	has_many :comments
	has_many :articles
	has_many :availabilities
	has_many :notifications
	has_many :relationships
	has_many :instances, :through => :relationships
end
