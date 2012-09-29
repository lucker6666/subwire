#   Schema
# ==========
#   table: links
#
#   link_id       :integer    not null, primary key
#   channel_id    :integer    not null, index
#   name          :string
#   href          :string
#   icon          :string
#   created_at    :datetime    not null
#   updated_at    :datetime    not null

class Link < ActiveRecord::Base
  ### Attributes
  attr_accessible :href, :name, :icon

  ### Associations
  belongs_to :channel

  ### Validations
  # Make sure, name, href and icon are not empty
  validates :name, :href, :icon, presence: true

  # Make sure, href is a url
  validates :href, :format => {
    with: /(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:\/~\+#]*[\w\-\@?^=%&amp;\/~\+#])?/,
  }

  class << self
    def find_all_by_channel_id_and_page(channel_id, page)
      where(:channel_id => channel_id).paginate(:page => page, :per_page => 10)
    end
  end

end
