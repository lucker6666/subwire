#   Schema
# ==========
#   table: relationships
#
#   relationship_id      :integer    not null, primary key
#   user_id              :integer    not null, index
#   channel_id          :integer    not null, index
#   admin                :boolean    not null, default => true
#   mail_notification                   :boolean        not null, default => true
#
# TODO: default false for admin?

class Relationship < ActiveRecord::Base
  ### Attributes
  attr_protected :user_id, :channel_id, :admin

  ### Associations
  belongs_to :channel
  belongs_to :user


  ### Methods

  def self.is_user_admin_of_channel?(user, channel)
    where(channel_id: channel.id, user_id: user.id, admin: true).any?
  end

  def self.find_all_users_by_channel(channel)
    result = []

    where(channel_id: channel.id).each do |rel|
      unless rel.user.invitation_pending || rel.user.is_deleted
        result << rel.user
      end
    end

    return result
  end

  def self.find_by_channel_and_user(channel, user)
    where(
      channel_id: channel.id,
      user_id: user.id
    ).first
  end

  def self.find_all_by_channel_id_and_page(channel_id, page)
    where(channel_id: channel_id).paginate(page: page, per_page: 10)
  end

  def email
    unless user.nil?
      return user.email
    end

    return ""
  end
end
