// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
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