module InstancesHelper
	def instances
		Instance.find_all_by_user(current_user)
	end
end