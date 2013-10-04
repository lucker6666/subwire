#   Schema
# ==========
#   table: channels
#
#   channel_id        :integer    not null, primary key
#   name              :string      not null
#   permalink         :string    not null, unique
#   defaultLanguage   :string      not null, default => "en"
#   advertising       :boolean    not null, default => true
#   planningTool      :boolean    not null, default => false
#   created_at        :datetime    not null
#   updated_at        :datetime    not null

class Channel < ActiveRecord::Base
  ### Attributes
  attr_accessible :name, :defaultLanguage, :planningTool

  ### Associations
  has_many :messages
  has_many :availabilities
  has_many :notifications
  has_many :relationships
  has_many :pages
  has_many :users, through: :relationships

  ### Permalink
  has_permalink :name, :min_length => 3

  ### Validations
  # Make sure, name is not empty and maximum 30 chars length
  validates :name, presence: true, length: {
    maximum: 30
  }

  validates :defaultLanguage, inclusion: {
    in: %w(en de)
  }


  ### Methods

  def self.find_by_id_or_permalink(param)
    if param.to_s =~ /^\d+$/
      find_by_id(param)
    else
      find_by_permalink(param)
    end
  end

  def self.find_all_where_user_is_admin(user)
    find(
      :all,
      joins: :relationships,
      conditions: {
        "relationships.user_id" => user.id,
        "relationships.admin" => true
      }
    )
  end

  def self.find_all_by_user(user)
    find(
      :all,
      joins: :relationships,
      conditions: { "relationships.user_id" => user.id }
    )
  end
  
  def self.can_invite_users_to_channel(user, channel)
    channels = Array.new
    Channel.find_all_by_user(user).each do |c|
      if c != channel
        relationships = Array.new
        Relationship.find_all_by_channel_id(c.id).each do |r|
          if r.user != user
            relationships.push(r)
          end
        end
        if relationships.length > 0
          channels.push(relationships)
        end
      end
    end
    channels
  end

  def message_count
    Message.find_all_by_channel_id(id).length
  end

  def user_count
    Relationship.find_all_by_channel_id(id).length
  end

  def notification_count(user)
    Notification.where(
      channel_id: id,
      user_id: user.id,
      is_read: false
    ).length
  end
end