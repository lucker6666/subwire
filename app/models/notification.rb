#   Schema
# ==========
#   table: notifications
#
#   notification_id      :integer    not null, primary key
#   user_id              :integer
#   channel_id          :integer    not null, index
#   notification_type    :string      default => "article"
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
  attr_accessible :notification_type, :message, :is_read, :provokesUser, :subject, :href, :created_by

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
      unless user == from or except.include?(user)
        self.notify_user(from, user, data[:notification_type], data[:provokesUser], data[:subject],
          data[:href], channel)
      end
    end
  end

  def self.notify_user(from, user, notification_type, provokesUser, subject, href, channel)
    notification = Notification.new({
      notification_type: notification_type,
      provokesUser: provokesUser,
      subject: subject,
      href: href,
      created_by: from
    })

    notification.is_read = false
    notification.user = user
    notification.channel = channel

    notification.save

    # Notify user via email
    if (user.last_activity < Time.now-120 && Relationship.find_by_channel_and_user(channel, user).mail_notification && (data[:notification_type] == 'new_article' or data[:notification_type] == 'new_comment'))
      NotifyMailer.notify(User.find(data[:provokesUser]), user, notification ).deliver
    end
  end

  def avatar_path
    @user = User.find(self.provokesUser)

    if(@user.gravatar)
      'http://www.gravatar.com/avatar/' + @user.gravatar + '?s=30'
    else
      @user.avatar.url
    end
  end

  def message
    "<strong>" + I18n.t("notifications." + self.notification_type, user: User.find(self.provokesUser).name) + "</strong> <br />#{self.subject}"
  end

  def read!
    self.is_read = true
    self.save
  end

  # Returns an array of notifications for an user and an channel
  def self.find_all_relevant(channel, user)
    return if channel.nil?


      notifications = order("is_read").order("created_at DESC").limit(5).where(
      user_id: user.id,
      channel_id: channel.id
      )

    if notifications.nil?
      notifications = []
    end

    notifications
  end

  def self.all_notifications_count(user_id)
    Notification.where(
        user_id: user_id,
        is_read: false
    ).size
  end
end
