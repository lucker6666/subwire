$(function() {
    $('[id^=mai-link]').click(function() {
        var is_important = $(this).attr('data-is-important') != 'true';
        var id = $(this).attr('data-id');

        $.post('messages/' + id + '/mark_as_important', {
            is_important: is_important
        },
        function(json) {
            if(!json.r) {
                alert('Sorry something goes wrong, please try again.')
            } else {
                if (!is_important)
                    $('#mai-link-' + id).text('mark as important');
                else
                    $('#mai-link-' + id).text('unmark important');

                $('#mai-link-' + id).attr('data-is-important', is_important);
            }
        }, "json");
    });

	$('.comment-list').hide();
    $('.autogrow').autoGrow();
});


function commentToggle(a) {
    $(a).parents('.message').find('.comment-list').slideToggle();

    return false;
}


function editComment(comment) {
    $('.comment-edit').hide("slow");
    $('.comment').show("slow");
    $('#comment' + comment).hide("slow");
    $('#comment' + comment + 'edit').show("slow");
    return false;
}

function loadAllComments(channelId, messageId) {
    $.get('/channels/' + channelId + '/messages/' + messageId + '/comments/load_all/',
	    {},
	    function(html) {
	    	var e = $('#message-comments-' + messageId);
	        e.html(html);
	    }
	);
}