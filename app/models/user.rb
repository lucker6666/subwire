#   Schema
# ==========
#   table: users
#
#   user_id               :integer    not null, primary key
#   name                  :string     not null
#   email                 :string     not null
#   is_admin              :boolean    not null, default => false
#   encrypted_password    :string     not null
#   remember_created_at   :datetime
#   lang                  :string     not null, default => "en"
#   created_at            :datetime   not null
#   updated_at            :datetime   not null
#   timezone              :string     not null, default => "Central Time (US & Canada)"
#   avatar_file_name"     :string
#   avatar_content_type"  :string
#   avatar_file_size"     :integer
#   avatar_updated_at"    :datetime
#   is_deleted            :boolean
#   gravatar              :string
#   last_activity         :date
#   provider              :string
#   uid                   :string


class User < ActiveRecord::Base
  ### Devise
  devise :database_authenticatable, :registerable, :rememberable, :validatable, :confirmable,
    :recoverable, :omniauthable

  ### Attributions
  attr_accessible :name, :email, :password, :password_confirmation,
    :remember_me, :last_seen, :lang, :avatar, :timezone, :show_login_status, :provider, :uid

  ### Associations
  has_many :comments
  has_many :messages
  has_many :availabilities
  has_many :notifications
  has_many :relationships
  has_many :wikis
  has_many :channels, through: :relationships

  ### Paperclip Avatar
  has_attached_file :avatar,
    default_style: :default,
    default_url: '/assets/anonymous.png',
    styles: {
      small: "50x50#",
      tiny: "30x30#",
      list: "16x16#",
      default: "100x100#"
    }

  validates_attachment_size :avatar, less_than: 2.megabytes
  validates_attachment_content_type :avatar,
    content_type: ["image/jpeg", "image/pjpeg", "image/png", "image/x-png", "image/gif"]

  ### Validations
  # Make sure, name, email, lang, timezone are not empty
  validates :lang, :timezone, :email, presence: true

  # Make sure name contains no invalid chars and length is between 3 and 30
  validates :name, format: { with: /\A[a-zA-Z0-9\-_. ]+\z/ },
    length: { minimum: 3, maximum: 30 }

  # Make sure email looks like an email adress
  validates :email, format: {
    with: /\A[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.(([0-9]{1,3})|([a-zA-Z]{2,3})|(aero|coop|info|museum|name))\z/
  }

  # Make sure lang contains "de" or "en"
  validates :lang, inclusion: {
    in: %w(en de)
  }

  ### Methods

  def is_admin_of_channel?(channel)
    if is_admin
      true
    else
      Relationship.is_user_admin_of_channel?(self, channel)
    end
  end

  def channel_count
    Relationship.find_all_by_user_id(id).length
  end

  def login_status_by_time(time, name)
    return '#000' unless self.show_login_status?

    if name == self.name || self.last_activity == nil || (self.last_activity + 3.minutes) >= time
      "#157f00" # green -> online
    else
      "#cc0022" # red -> offline
    end
  end

  def can_invite_user_to_channels(user)
    canInvite = Array.new
    Channel.find_all_where_user_is_admin(self).each do |c|
      if Relationship.find_by_channel_and_user(c, user).nil?
        canInvite.push(c)
      end
    end
    canInvite
  end

  def login_status(name)
    login_status_by_time Time.now, name
  end

  def may_create_new_channel?
    return self.is_admin? ||
      Channel.find_all_where_user_is_admin(self).length < 5
  end

  def self.find_for_authentication(conditions)
      super(conditions.merge(is_deleted: false))
  end

  def self.find_for_googleapps_oauth(access_token, signed_in_resource=nil)
    data = access_token['info']
    if user = User.where(:email => data['email']).first
      return user
    else
      User.create!(:name => data['name'], :email => data['email'], :password => Devise.friendly_token[0,20], :provider => access_token['provider'],:uid => access_token['uid'])
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    users = User.where(:email => auth.info.email)

    unless user
     user = User.create!(name:auth.extra.raw_info.name,
                       provider:auth.provider,
                       uid:auth.uid,
                       email:auth.info.email,
                       password:Devise.friendly_token[0,20],
                       )
    end
    user
  end

  def self.find_all_active_by_page(page)
    where(is_deleted: false, invitation_pending: false).paginate(page: page, per_page: 10)
  end
end
