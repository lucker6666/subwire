module ApplicationHelper
  # Truncate message for message overview
  def message_teaser(message)
    content = preprocess_message(message)
    target = channel_message_path(message.channel, message)
    HTML_Truncator.truncate(content, 60, ellipsis: ' ' + link_to('[...]', target)).strip.html_safe
  end

  # Preproccessing for messages
  def preprocess_message(message)
    content = auto_link(message.content).strip.html_safe
  end

  # Display boolean values as icon
  def boolean_icon(expression)
    content_tag :i, "", class: (expression ? "icon icon-ok" : "icon icon-remove")
  end

  # Convert String to jGrowl Notification JS Code
  def jGrowl_message(msg)
    "$.jGrowl(\"#{msg}\");"
  end

  # Returns the JS Code of all flash messages including Devise model errors
  def flash_messages
    messages = []

    # Add all Devise model errors to the result array
    if defined?(@user) && !@user.nil? && !@user.errors.empty?
      @user.errors.full_messages.map { |msg| messages.push(jGrowl_message(msg)) }
    end

    # Add all flash messages to the result array
    flash.each do |key, message|
      # In some cases message maybe an array too
      if message.kind_of? Array
        message.each { |msg| messages.push(jGrowl_message(msg)) }
      else
        messages.push(jGrowl_message(message))
      end
    end

    flash.clear

    messages.join.html_safe
  end

  # Generates img-Tag vor avatar
  def avatar(user, size = :small, className = "")
    case size
    when :small
      width = 50
      height = 50

    when :tiny
      width = 30
      height = 30

    when :list
      width = 16
      height = 16

    when :big
    else
      width = 100
      height = 100
    end

    if user.gravatar
      image_tag 'http://www.gravatar.com/avatar/' + user.gravatar + '?s=' + width.to_s(),
      class: 'avatar ' + className + " size-" + size.to_s, width: width, height: height
    else
      image_tag user.avatar.url(size), class: 'avatar ' + className,
        width: width, height: height
    end
  end

  # Random background image for login page
  def login_background
    backgrounds = Subwire::Application.config.backgrounds
    return backgrounds[Random.new.rand(0..(backgrounds.length - 1))]
  end

  # Existing icons
  def icons
    [
       'glass',
       'music',
       'search',
       'envelope',
       'heart',
       'star',
       'star-empty',
       'user',
       'film',
       'th-large',
       'th',
       'th-list',
       'ok',
       'remove',
       'zoom-in',
       'zoom-out',
       'off',
       'signal',
       'cog',
       'trash',
       'home',
       'file',
       'time',
       'road',
       'download-alt',
       'download',
       'upload',
       'inbox',
       'play-circle',
       'repeat',
       'refresh',
       'list-alt',
       'lock',
       'flag',
       'headphones',
       'volume-off',
       'volume-down',
       'volume-up',
       'qrcode',
       'barcode',
       'tag',
       'tags',
       'book',
       'bookmark',
       'print',
       'camera',
       'font',
       'bold',
       'italic',
       'text-height',
       'text-width',
       'align-left',
       'align-center',
       'align-right',
       'align-justify',
       'list',
       'indent-left',
       'indent-right',
       'facetime-video',
       'picture',
       'pencil',
       'map-marker',
       'adjust',
       'tint',
       'edit',
       'share',
       'check',
       'move',
       'step-backward',
       'fast-backward',
       'backward',
       'play',
       'pause',
       'stop',
       'forward',
       'fast-forward',
       'step-forward',
       'eject',
       'chevron-left',
       'chevron-right',
       'plus-sign',
       'minus-sign',
       'remove-sign',
       'ok-sign',
       'question-sign',
       'info-sign',
       'screenshot',
       'remove-circle',
       'ok-circle',
       'ban-circle',
       'arrow-left',
       'arrow-right',
       'arrow-up',
       'arrow-down',
       'share-alt',
       'resize-full',
       'resize-small',
       'plus',
       'minus',
       'asterisk',
       'exclamation-sign',
       'gift',
       'leaf',
       'fire',
       'eye-open',
       'eye-close',
       'warning-sign',
       'plane',
       'calendar',
       'random',
       'comment',
       'magnet',
       'chevron-up',
       'chevron-down',
       'retweet',
       'shopping-cart',
       'folder-close',
       'folder-open',
       'resize-vertical',
       'resize-horizontal',
       'hdd',
       'bullhorn',
       'bell',
       'certificate',
       'thumbs-up',
       'thumbs-down',
       'hand-right',
       'hand-left',
       'hand-up',
       'hand-down',
       'circle-arrow-right',
       'circle-arrow-left',
       'circle-arrow-up',
       'circle-arrow-down',
       'globe',
       'wrench',
       'tasks',
       'filter',
       'briefcase',
       'fullscreen'
    ]
  end
end
