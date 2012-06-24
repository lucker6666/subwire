//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jgrowl.js
//= require ckeditor/init
//= require_tree .

$(function() {
	$('.commentContainer').hide();
	$('a.availability_cell').click(switchAvailability);
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

function commentToggle(a) {
	a = $(a);
	span = a.children('span');

	if (span.hasClass('icon-chevron-right')) {
		a.siblings('.commentContainer').slideDown();
		span.removeClass('icon-chevron-right');
		span.addClass('icon-chevron-down');
	} else {
		a.siblings('.commentContainer').slideUp();
		span.removeClass('icon-chevron-down');
		span.addClass('icon-chevron-right');
	}

	return false;
}


function editComment(comment) {
	$('.comment-edit').hide("slow");
	$('.comment').show("slow");
	$('#comment' + comment).hide("slow");
	$('#comment' + comment + 'edit').show("slow");
	return false;
}

function updateNotifications() {
  $.getJSON('/notifications.json', function(data) {
	  var notifications = "";
	  var notificationsCount = 0;

	  $.each(data, function(key, val) {
	    notifications += '<li><a href="/notifications/' + val.id + '">';
	    notifications += '<img class="avatar" height="30" src="' + val.avatar_path + '" width="30">';
	    notifications +=  val.message + '</a></li>';
	    ++notificationsCount;
	  });

	  if(notificationsCount > 0) {
	  	var ul = $('ul.notification-dropdown');
	  	var a = ul.siblings("a");
	  	ul.html(notifications);

	  	if (a.children("span").length > 0) {
	  		a.children("span").html(notificationsCount);
	  	} else {
		  	a.append("<span class='notification-badge badge badge-info'>" +
		  		notificationsCount + "</span>");
	  	}

		$('title').html(window.subwireTitle + ' ('+notificationsCount+')');
	  }
  });
}

setInterval("updateNotifications();", 60000);
