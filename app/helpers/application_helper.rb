module ApplicationHelper
	include Session

	# Display boolean values as icon
	def boolean_icon(expression)
		content_tag :i, "", :class => (expression ? "icon icon-ok" : "icon icon-remove")
	end

	# Returns true if ad banner should be displayed
	def display_ads
		if current_user.is_admin?
			false
		end

		current_instance.advertising
	end

	def flash_messages
		if defined?(@user) && !@user.nil? && !@user.errors.empty?
			flash[:alert] ||= []
			@user.errors.full_messages.map do |msg|
				flash[:alert].push(msg)
    	end
  	end

  	messages = []

		flash.each do |key, message|
			if message.kind_of? Array
				message.each do |msg|
					messages.push("$.jGrowl(\"#{msg}\");")
				end
			else
				messages.push("$.jGrowl(\"#{message}\");")
			end
		end

		flash.clear

		messages.join.html_safe
	end

	def avatar(user, size = :small, className = "")
		if size == :small
			width = 50
			height = 50
		elsif size == :tiny
			width = 30
			height = 30
		else
			width = 100
			height = 100
		end

		image_tag user.avatar.url(size), :class => 'avatar ' + className,
				:width => width, :height => height
	end

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
