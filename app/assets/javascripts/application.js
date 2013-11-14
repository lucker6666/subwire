//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require underscore
//= require backbone
//= require backbone_rails_sync
//= require backbone_datalink
//= require messenger
//= require jquery.autogrowtextarea.min.js
//= require jquery.color.min.js
//= require ckeditor/init
//= require_tree .

$(function() {
    $(document).on('click', 'a.availability-cell', switchAvailability);

    $('.btn').not('.no-lock').click(function(e) {
        if ($(this).hasClass('btn-disabled')) {
            e.preventDefault();
            return false;
        } else {
            $(this).addClass('btn-disabled');
            return true;
        }
    });

    refreshUserBox();
    getAllNotifications();

    // Hide tooltips on click
    $('[rel=tooltip]').click(function(e) {
    	$(e.currentTarget).tooltip('hide');
    });

    // Notifications link
    $('#notifications').popover({
		placement: 'bottom',
		title: 'Notifications', // TODO translation
		html: true,
		content: $('#notifications-html').html()
	});

    // New Message link
    $('#new-message').popover({
		placement: 'bottom',
		title: 'New message', // TODO translation
		html: true,
		content: $('#new-message-html').html()
	});

    // Planning tool link
    $('#planning-tool').popover({
		placement: 'bottom',
		title: "When you're available?", // TODO translation
		html: true,
		content: function() {
			return $('#planning-tool-html').html();
		}
	});
});

function markAllAsRead(){
  $.ajax({
    url: '/notifications/1.json',
    type: 'DELETE',
    dataType: 'json',
    success: function(data) {
      updateNotificationsInner(data);
    }
  });
}

function switchAvailability(event) {
    var a = $('a#' + $(event.currentTarget).attr('id')),
    	icon = a.children('i'),
    	td = a.closest('td');

    console.log(a, $(event.currentTarget), $(event.currentTarget).attr('id'));

    switch (td.attr('class')) {
        case "yellow":
        case "red":
            td.removeClass('yellow').removeClass('red').addClass('green');
            icon.removeClass('icon-remove').removeClass('icon-question-sign').addClass('icon-ok');

            $.post(window.channel_path + "/availability", {
                date: a.attr('alt'),
                value: true
            });

            break;

        case "green":
            td.removeClass('green').addClass('red');
            icon.removeClass('icon-ok').addClass('icon-remove');

            $.post(window.channel_path + "/availability", {
                date: a.attr('alt'),
                value: false
            });

            break;
    }

    return false;
}

function updateNotificationsInner(data) {
    var notifications = "";
    var notificationsCount = 0;
    var notifcationsChannelCount = [];

    $.each(data, function(key, val) {
        classAttr = '';

        if (val.is_read) {
            classAttr = ' class="read"';
        } else {
            ++notificationsCount;
            if(notifcationsChannelCount[val.channel_id])
                ++notifcationsChannelCount[val.channel_id];
            else
                notifcationsChannelCount[val.channel_id] = 1;
        }

        notifications += '<li' + classAttr + '><a href="/notifications/' + val.id + '">';
        notifications += '<img class="avatar" height="30" src="' + val.avatar_path + '" width="30">';
        notifications += val.message + '</a></li><li class="divider"></li>';
    });

    notifications += '<li><a id="read-all" href="#" onclick="markAllAsRead()">' + $('#read-all').html() + '</a></li>';
    var ul = $('<ul></ul>');
    var a = $('#notifications > a');
    a.children("span").remove();
    if (notifications) {
        ul.html(notifications);
    }

    if (notificationsCount > 0) {
        if (a.children("span").length > 0) {
            a.children("span").html(notificationsCount);
        } else {
            a.append("<span class='notification-badge badge badge-important'>" +
                    notificationsCount + "</span>");
        }

        $('title').html(' (' + notificationsCount + ')' + window.subwireTitle);
        $('#notifications').addClass('unread');
    } else {
        $('title').html(window.subwireTitle);
        $('#notifications').removeClass('unread');
    }
   return ul;
}

function refreshUserBox() {
    $.get('/ajax/users/load_user_box?r=' + Math.random(), {}, function(c) {
        $('#user-box').html(c);
        setTimeout("refreshUserBox()", 30000);
    });
}

function getAllNotifications() {
      $.getJSON('/notifications.json', function(data) {
        $('#notifications').data('popover').options.content = updateNotificationsInner(data);
        setTimeout("getAllNotifications()", 30000);
    });
}
