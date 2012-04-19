class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :validatable

  attr_accessible :login, :is_admin, :name, :email, :password, :password_confirmation,
  	:remember_me, :color, :last_seen
end
