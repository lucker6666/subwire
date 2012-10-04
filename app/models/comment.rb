#   Schema
# ==========
#   table: comments
#
#   comment_id  :integer    not null, primary key
#   user_id      :integer
#   article_id  :integer
#   created_at  :datetime    not null
#   updated_at  :datetime    not null
#
# TODO: index for article_id
# TODO: article_id, user_id not null?

class Comment < ActiveRecord::Base
  ### Attributes
  attr_accessible :content, :article_id

  ### Associations
  belongs_to :article
  belongs_to :user

  # Law of demeter delegations
  delegate :name, :to => :user, :prefix => true

  ### Validations
  # Make sure, content is not empty
  validates :content, presence: true

  scope :newest, :order => 'id DESC'
#  scope :by_article_id, :order_bu => 'created_at DESC'
end
