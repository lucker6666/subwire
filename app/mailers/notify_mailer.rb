class NotifyMailer < ActionMailer::Base
  default from: "no-reply@subwire.net"

    def notify(fromUser, toUser, notification)
    @toUser = toUser
    @fromUser = fromUser
    @notification = notification

    I18n.locale = @toUser.lang

    mail :to => "#{toUser.email}",
      :subject => t('notifications.mailer.subject', :notification =>  t('notifications.mailer.' + notification.notification_type), :user => fromUser.name)


    I18n.locale = @fromUser.lang
  end
end
