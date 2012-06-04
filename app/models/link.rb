class Link < ActiveRecord::Base
	attr_accessible :href, :name, :icon

	belongs_to :instance
end
