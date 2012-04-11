class User < ActiveRecord::Base
  attr_accessible :email, :login,

  has_secure_password

  has_many :articles
  has_many :comments
end
