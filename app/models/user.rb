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
#		created_at 						:datetime		not null
#		updated_at 						:datetime		not null
# 	timezone							:string 		not null, default => "Central Time (US & Canada)"
# 	avatar_file_name"			:string
# 	avatar_content_type"	:string
# 	avatar_file_size"			:integer
# 	avatar_updated_at"		:datetime
#   is_deleted				:boolean
#   gravatar                :string
#   last_activity           :date
#


class User < ActiveRecord::Base
	### Devise
	devise :database_authenticatable, :registerable, :rememberable, :validatable, :confirmable,
		:recoverable

	### Attributions
	attr_accessible :name, :email, :password, :password_confirmation,
		:remember_me, :last_seen, :lang, :avatar, :timezone, :show_login_status

	### Associations
	has_many :comments
	has_many :articles
	has_many :availabilities
	has_many :notifications
	has_many :relationships
	has_many :instances, :through => :relationships

	### Paperclip Avatar
	has_attached_file :avatar,
		:default_style => :default,
		:default_url => '/assets/anonymous.png',
		:styles => {
			:small => "50x50#",
			:tiny => "30x30#",
			:list => "16x16#",
			:default => "100x100#"
		}

	validates_attachment_size :avatar, :less_than => 2.megabytes
	validates_attachment_content_type :avatar,
    :content_type => ["image/jpeg", "image/pjpeg", "image/png", "image/x-png", "image/gif"]

	### Validations
	# Make sure, name, email, lang, timezone are not empty
	validates :lang, :timezone, :presence => true

	# Make sure name contains no invalid chars and length is between 3 and 30
	validates :name, :format => { :with => /[a-zA-Z0-9\-_. ]+/ },
		:length => { :minimum => 3, :maximum => 30 }

	# Make sure email looks like an email adress
	validates :email, :format => {
		:with => /^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.(([0-9]{1,3})|([a-zA-Z]{2,3})|(aero|coop|info|museum|name))$/
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

  def login_status_by_time(time, name)
    return 'none' unless self.show_login_status?
    return "online" if (self.last_activity + 3.minutes) >= time || name == self.name
    "offline"
  end

  def login_status(name)
    login_status_by_time Time.now, name
  end

	def self.find_for_authentication(conditions)
  		super(conditions.merge(:is_deleted => false))
	end
end
