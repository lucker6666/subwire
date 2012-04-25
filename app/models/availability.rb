class Availability < ActiveRecord::Base
  belongs_to :user
  attr_accessible :date, :value, :user
end
