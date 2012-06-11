class Link < ActiveRecord::Base
	attr_accessible :href, :name, :icon, :instance

	belongs_to :instance
end
