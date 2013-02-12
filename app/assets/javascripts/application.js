//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jgrowl.js
//= require jquery.autogrowtextarea.min.js
//= require ckeditor/init
//= require_tree .

$(function() {
    $('a.availability_cell').click(switchAvailability);

    $('.btn').not('.no-lock').click(function(e) {
        if ($(this).hasClass('btn-disabled')) {
            e.preventDefault();
            return false;
        } else {
            $(this).addClass('btn-disabled');
            return true;
        }
    });

    $('#markAllNotificationsAsRead').click(function(e) {
        $.ajax({
            url: '/notifications/1.json',
            type: 'DELETE',
            dataType: 'json',
            success: function(data) {
                updateNotificationsInner(data);
            }
        });
    });

    refreshUserBox();
    getAllNotifications();

    // Hide tooltips on click
    $('[rel=tooltip]').click(function(e) {
    	$(e.currentTarget).tooltip('hide');
    });

    // New Message link
    $('#new-message').popover({
		placement: 'bottom',
		title: 'New message',
		html: true,
		content: $('#new-message-html').html()
	});
});


function switchAvailability(event) {
    var a = $(event.currentTarget);
    var icon = a.children('i');
    var td = a.closest('td');

    switch (td.attr('class')) {
        case "yellow":
        case "red":
            td.removeClass('yellow').removeClass('red').addClass('green');
            icon.removeClass('icon-remove').removeClass('icon-question-sign').addClass('icon-ok');

            $.post("/availability", {
                date: a.attr('alt'),
                value: true
            });

            break;

        case "green":
            td.removeClass('green').addClass('red');
            icon.removeClass('icon-ok').addClass('icon-remove');

            $.post("/availability", {
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

    $.each(data, function(key, val) {
        classAttr = '';

        if (val.is_read) {
            classAttr = ' class="read"';
        } else {
            ++notificationsCount;
        }

        notifications += '<li' + classAttr + '><a href="/notifications/' + val.id + '">';
        notifications += '<img class="avatar" height="30" src="' + val.avatar_path + '" width="30">';
        notifications += val.message + '</a></li><li class="divider"></li>';
    });

    notifications += '<li class="divider"></li><li><a id="markAllNotificationsAsRead" href="#">' + $('#markAllNotificationsAsRead').html() + '</a></li>';
    var ul = $('ul.notification-dropdown');
    var a = ul.siblings("a");
    a.children("span").remove();
    if (notifications) {
        ul.html(notifications);
    }

    if (notificationsCount > 0) {
        if (a.children("span").length > 0) {
            a.children("span").html(notificationsCount);
        } else {
            a.append("<span class='notification-badge badge badge-info'>" +
                    notificationsCount + "</span>");
        }

        $('title').html(' (' + notificationsCount + ')' + window.subwireTitle);
    } else {
        $('title').html(window.subwireTitle);
    }
}

function updateNotifications() {
    $.getJSON('/notifications.json', function(data) {
        updateNotificationsInner(data);
    });
}

if (window.pollNotifications) {
    setInterval("updateNotifications();", 60000);
}

function refreshUserBox() {
    $.get('/ajax/users/load_user_box?r=' + Math.random(), {}, function(c) {
        $('#user-box').html(c);
        setTimeout("refreshUserBox()", 30000);
    });
}

function getAllNotifications() {
    $.get('/ajax/notifications/load_all_notifications',
        {},
        function(html) {
            $('#channel-switcher').html(html);
            setTimeout("getAllNotifications()", 30000);
        });
}