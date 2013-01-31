#   Schema
# ==========
#   table: articles
#
#   article_id  :integer    not null, primary key
#   title       :string
#   content     :text
#   user_id      :integer
#   channel_id  :integer    not null, index
#   created_at  :datetime    not null
#   updated_at  :datetime    not null
#
# TODO: index for user_id?
# TODO: user_id, title -> not_null?

class Article < ActiveRecord::Base


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

  ### Validations
  # Make sure, title and content are not empty
  validates :title, :content, presence: true

  def newest_comments
    Comment.newest.find_all_by_article_id self.id
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
