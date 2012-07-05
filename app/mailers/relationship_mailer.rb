class RelationshipMailer < ActionMailer::Base
	def invitation(user, current_user)
		@user = user
		@current_user = current_user
		mail :to => "#{user.email}",
			:subject => t('relationships.mail.invitation.subject', :user => current_user.name),
			:from => Devise.mailer_sender
	end
end
