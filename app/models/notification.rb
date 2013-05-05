#   Schema
# ==========
#   table: notifications
#
#   notification_id      :integer    not null, primary key
#   user_id              :integer
#   channel_id          :integer    not null, index
#   notification_type    :string      default => "message"
#   message              :string
#   href                :string
#   is_read              :boolean
#   created_at          :datetime    not null
#   updated_at          :datetime    not null
#
# TODO: index for channel_id
# TODO: index for user_id
# TODO: not null user_id, notification_type


class Notification < ActiveRecord::Base
  ### Attributes
  attr_accessible :notification_type, :message, :is_read, :provokesUser, :subject, :href,
    :created_by, :data1, :data2

  ### Associations
  belongs_to :user
  belongs_to :user, foreign_key: "created_by"
  belongs_to :channel

  ### Validations
  # Make sure, notification_type, message, href, is_read are not empty
  validates :notification_type, :created_by, :href, presence: true


  ### Methods

  def self.notify_all_users(data, channel, from, options = {})
    except = options[:except] || []

    Relationship.find_all_users_by_channel(channel).each do |user|
      unless user == from || except.include?(user)
        data[:from] = from
        self.notify_user(user, channel, data)
      end
    end
  end

  def self.notify_user(user, channel, params = {})
    type = params[:notification_type].to_sym

    notification = Notification.new({
      notification_type: type,
      provokesUser: params[:provokesUser].id,
      subject: params[:subject],
      href: params[:href],
      created_by: params[:from].id
    })

    # Additional data
    if params[:data].kind_of?(Array)
      notification.data1 = params[:data][0] || nil
      notification.data2 = params[:data][1] || nil
    end

    notification.is_read = false
    notification.user = user
    notification.channel = channel

    notification.save!

    # Notify user via email if neccessary
    active = (user.last_activity != nil && user.last_activity >= Time.now - 120)
    notifications_enabled = Relationship.find_by_channel_and_user(channel, user).mail_notification
    relevant_type = [:new_message, :new_comment].include?(type)

    if (active && notifications_enabled && relevant_type)
      NotifyMailer.notify(User.find(params[:provokesUser]), user, notification).deliver
    end
  end

  def avatar_path
    @user = User.find(self.created_by)

    if(@user.gravatar)
      'http://www.gravatar.com/avatar/' + @user.gravatar + '?s=30'
    else
      @user.avatar.url
    end
  end

  def message
    args = {
      user: User.find(self.provokesUser).name
    }

    if self.data1
      args[:data1] = self.data1
    end

    if self.data2
      args[:data1] = self.data2
    end

    message = I18n.t("notifications." + self.notification_type, args)

    "<strong>#{message}</strong> <br />#{self.subject}"
  end

  def read!
    self.is_read = true
    self.save!
  end

  # Returns an array of notifications for an user and an channel
  def self.find_all_relevant(channel, user)
    return if channel.nil?

    notifications = order("is_read").order("created_at DESC").limit(5).where(
      user_id: user.id,
      channel_id: channel.id
    )

    notifications
  end

  def self.all_notifications_count(user_id)
    Notification.where(
        user_id: user_id,
        is_read: false
    ).size
  end

  def channel_name
    self.channel.name
  end
end
