class Wiki < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel
  attr_accessible :content, :title

  validates :title, presence: true, length: {
    maximum: 60
  }
end
