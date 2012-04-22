class Comment < ActiveRecord::Base
  attr_accessible :content

  belongs_to :article
  belongs_to :user
end