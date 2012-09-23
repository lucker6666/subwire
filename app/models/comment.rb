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

  ### Validations
  # Make sure, content is not empty
  validates :content, presence: true
end
