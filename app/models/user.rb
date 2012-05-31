class User < ActiveRecord::Base
	devise :database_authenticatable, :rememberable, :validatable

	attr_accessible :is_admin, :name, :email, :password, :password_confirmation,
		:remember_me, :color, :last_seen, :relationship, :lang

	has_many :comments
	has_many :articles
	has_many :availabilities
	has_many :notifications
	has_many :relationships
	has_many :instances, :through => :relationships

	def is_admin_of_instance?(instance)
		if is_admin
			true
		else
			Relationship.is_user_admin_of_instance?(self, instance)
		end
	end
end
