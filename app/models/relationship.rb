class Relationship < ActiveRecord::Base
	attr_accessible :admin, :instance, :user

	belongs_to :instance
	belongs_to :user

	def self.is_user_admin_of_instance?(user, instance)
		where(:instance_id => instance.id, :user_id => user.id, :admin => true).any?
	end
end
