class NotifyMailer < ActionMailer::Base
  default from: "no-reply@subwire.net"

  	def notify(fromUser, toUser, notification)
		@toUser = toUser
		@fromUser = fromUser
		@notification = notification

		mail :to => "#{toUser.email}",
			:subject => t('notifications.mailer.subject', :notification =>  t('notifications.mailer.' + notification.notification_type), :user => fromUser.name)
	end
end
