#   Schema
# ==========
#   table: links
#
#   link_id       :integer    not null, primary key
#   channel_id    :integer    not null, index
#   name          :string
#   href          :string
#   created_at    :datetime    not null
#   updated_at    :datetime    not null

class Link < ActiveRecord::Base
  ### Attributes
  attr_accessible :href, :name, :position

  ### Associations
  belongs_to :channel

  ### Validations
  # Make sure, name and href are not empty
  validates :name, :href, presence: true

  # Make sure, href is a url
  validates :href, format: {
    with: /\A(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:\/~\+#]*[\w\-\@?^=%&amp;\/~\+#])?\z/,
  }

  before_create :set_position

  class << self
    def find_all_by_channel_id_and_page(channel_id, page)
      find_all_by_channel_id(channel_id).paginate(page: page, per_page: 10)
    end

    def find_all_by_channel_id(channel_id)
      where(channel_id: channel_id).order('position')
    end
  end

  def move_position_up!
    Link.transaction do
      prev = Link.find_by_channel_id_and_position self.channel_id, self.position - 1
      if prev
        prev.position += 1
        prev.save!
      end

      self.position -= 1
      save!
    end
  end

  def move_position_dn!
    Link.transaction do
      next_link = Link.find_by_channel_id_and_position self.channel_id, self.position + 1
      if next_link
        next_link.position -= 1
        next_link.save!
      end

      self.position += 1
      save!
    end
  end

  def icon
    require 'open-uri'
    href_encoded = URI::encode(self.href)

    "<img class='favicon' src='https://plus.google.com/_/favicon?alt=page&domain=#{href_encoded}' />".html_safe
  end



  private

    def set_position
      self.position = next_position
    end

    def next_position
      count = Link.count(:group => :channel_id)[1]
      return 1 unless count
      count + 1
    end
end
