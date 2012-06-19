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
	### Devise
	devise :database_authenticatable, :registerable, :rememberable, :validatable

	### Attributions
	attr_accessible :name, :email, :password, :password_confirmation,
		:remember_me, :last_seen, :lang, :avatar, :timezone

	### Associations
	has_many :comments
	has_many :articles
	has_many :availabilities
	has_many :notifications
	has_many :relationships
	has_many :instances, :through => :relationships

	### Paperclip Avatar
	has_attached_file :avatar, :default_style => :default, :styles => {
		:small => "50x50#",
		:default => "100x100#"
	}

	### Validations
	# Make sure, name, email, lang, timezone are not empty
	validates :name, :email, :lang, :timezone, :presence => true

	# Make sure name contains no invalid chars and length is between 3 and 30
	validates :name, :format => { :with => /[a-zA-Z0-9-_. ]+/ },
		:length => { :minimum => 3, :maximum => 30 }

	# Make sure email looks like an email adress
	validates :email, :format => {
		:with => /^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.(([0-9]{1,3})|([a-zA-Z]{2,3})|(aero|coop|info|museum|name))$/,
		:message => "fail!"
	}

	# Make sure lang contains "de" or "en"
	validates :lang, :inclusion => {
		:in => %w(en de)
	}



	### Methods

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
