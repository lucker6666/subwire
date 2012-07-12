#   Schema
# ==========
# 	table: relationships
#
# 	relationship_id			:integer		not null, primary key
# 	user_id							:integer		not null, index
# 	instance_id					:integer		not null, index
# 	admin								:boolean		not null, default => true
#
# TODO: default false for admin?

class Relationship < ActiveRecord::Base
	### Attributes
	attr_protected :user_id, :instance_id, :admin

	### Associations
	belongs_to :instance
	belongs_to :user


	### Methods

	def self.is_user_admin_of_instance?(user, instance)
		where(:instance_id => instance.id, :user_id => user.id, :admin => true).any?
	end

	def self.find_all_users_by_instance(instance)
		result = []

		where(:instance_id => instance.id, :is_deleted => false, :invitation_pending => false).each do |rel|
			unless rel.user.invitation_pending
				result << rel.user
			end
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
