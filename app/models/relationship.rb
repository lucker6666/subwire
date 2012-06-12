class Relationship < ActiveRecord::Base
	attr_accessible :admin, :instance, :user

	belongs_to :instance
	belongs_to :user

	def self.is_user_admin_of_instance?(user, instance)
		where(:instance_id => instance.id, :user_id => user.id, :admin => true).any?
	end

	def self.find_all_users_by_instance(instance)
		result = []

		where(:instance_id => instance.id).each do |rel|
			result << rel.user
		end

		return result
	end

	def self.find_by_instance_and_user(instance, user)
		where(
			:instance_id => instance.id,
			:user_id => user.id
		).first
	end

	def email
		unless user.nil?
			return user.email
		end

		return ""
	end
end
