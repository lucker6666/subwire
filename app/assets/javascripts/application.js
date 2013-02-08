//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jgrowl.js
//= require jquery.autogrow.min.js
//= require ckeditor/init
//= require_tree .

$(function() {
    $('.commentContainer').hide();
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

    refreshUserBox();

    // Hide tooltips on click
    $('[rel=tooltip]').click(function(e) {
    	$(e.currentTarget).tooltip('hide');
    });

    $('textarea[class*=comment]').keypress(function(e) {
        if( e.keyCode == 13 && !e.shiftKey) {
            $(this).parent().submit();
        }
    })
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
    var commentContainer = $(a).parents('.message').find('.commentContainer');

    commentContainer.toggle();

    return false;
}


function editComment(comment) {
    $('.comment-edit').hide("slow");
    $('.comment').show("slow");
    $('#comment' + comment).hide("slow");
    $('#comment' + comment + 'edit').show("slow");
    return false;
}

function refreshUserBox() {
    $.get('/ajax/users/load_user_box?r=' + Math.random(), {}, function(c) {
        $('#user-box').html(c);
        setTimeout("refreshUserBox()", 30000);
    });
}
function loadAllComments(a_id) {

    $.get('/ajax/comments/load_all_comments/' + a_id,
    {},
    function(html) {
        $('#message-comments-' + a_id).html(html);
    });
}