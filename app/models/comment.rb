#   Schema
# ==========
#   table: comments
#
#   comment_id  :integer    not null, primary key
#   user_id      :integer
#   message_id  :integer
#   created_at  :datetime    not null
#   updated_at  :datetime    not null
#
# TODO: index for message_id
# TODO: message_id, user_id not null?

class Comment < ActiveRecord::Base
  ### Attributes
  attr_accessible :content, :message_id

  ### Associations
  belongs_to :message
  belongs_to :user

  # Law of demeter delegations
  delegate :name, :to => :user, :prefix => true

  ### Validations
  # Make sure, content is not empty
  validates :content, presence: true

  scope :newest, :order => 'id DESC'
#  scope :by_message_id, :order_bu => 'created_at DESC'
end
