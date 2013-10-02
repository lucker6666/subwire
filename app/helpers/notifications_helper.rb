module NotificationsHelper
  # Returns the icon for a notification
  def notification_icon(notification)
    icon = "file"

    case notification.notification_type.to_sym
      when :edit_message
        icon = "pencil"
      when :new_comment
        icon = "comment"
      when :new_calendar
        icon = "calendar"
      when :edit_wiki
      when :new_wiki
        icon = "book"
    end

    return "<i class=\"icon-#{icon}\"></i>".html_safe
  end
end
