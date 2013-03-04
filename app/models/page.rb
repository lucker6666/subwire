class Page < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel
  attr_accessible :content, :title
end
