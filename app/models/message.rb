#   Schema
# ==========
#   table: messages
#
#   message_id  :integer    not null, primary key
#   title       :string
#   content     :text
#   user_id      :integer
#   channel_id  :integer    not null, index
#   created_at  :datetime    not null
#   updated_at  :datetime    not null
#
# TODO: user_id, title -> not_null?

class Message < ActiveRecord::Base
  ### Attributes
  attr_accessible :content, :title, :is_editable

  ### Includes
  if Subwire::Application.config.elasticsearch
    include Tire::Model::Search
    include Tire::Model::Callbacks
  end

  ### Associations
  belongs_to :user
  belongs_to :channel
  has_many :comments

  # Law of demeter delegations
  delegate :name, to: :user, prefix: true

  ### Validations
  # Make sure, title and content are not empty
  validates :content, presence: true

  def newest_comments
    Comment.newest.find_all_by_message_id self.id
  end

  class << self
    def find_all_by_channel_id_and_page(channel_id, page)
      paginate(
        page: page,
        per_page: 5,
        order: "created_at DESC",
        conditions: { channel_id: channel_id }
      )
    end
  end
end
