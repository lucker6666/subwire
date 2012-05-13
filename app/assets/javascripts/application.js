//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jgrowl.js

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
}