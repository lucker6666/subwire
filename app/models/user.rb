#   Schema
# ==========
# 	table: users
#
# 	user_id								:integer		not null, primary key
# 	name									:string			not null
# 	email									:string			not null
# 	is_admin							:boolean		not null, default => false
#		encrypted_password		:string			not null
#		remember_created_at		:datetime
#		lang									:string			not null, default => "en"
# 	superadmin						:boolean		not null, default => "0"
#		created_at 						:datetime		not null
#		updated_at 						:datetime		not null
# 	timezone							:string 		not null, default => "Central Time (US & Canada)"
# 	avatar_file_name"			:string
# 	avatar_content_type"	:string
# 	avatar_file_size"			:integer
# 	avatar_updated_at"		:datetime
#
# TODO: remove superadmin


class User < ActiveRecord::Base
	devise :database_authenticatable, :registerable, :rememberable, :validatable

	attr_accessible :name, :email, :password, :password_confirmation,
		:remember_me, :last_seen, :lang, :avatar, :timezone

	has_many :comments
	has_many :articles
	has_many :availabilities
	has_many :notifications
	has_many :relationships
	has_many :instances, :through => :relationships

	has_attached_file :avatar, :default_style => :default, :styles => {
		:small => "50x50#",
		:default => "100x100#"
	}

	def is_admin_of_instance?(instance)
		if is_admin
			true
		else
			Relationship.is_user_admin_of_instance?(self, instance)
		end
	end

	def instance_count
		Relationship.find_all_by_user_id(id).length
	end
end
