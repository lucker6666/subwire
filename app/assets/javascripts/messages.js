$(document).ready(function() {

    $('[id^=mai-link]').click(function() {

        var is_important = $(this).attr('data-is-important') != 'true';
        var id = $(this).attr('data-id');

        $.post('/ajax/message/mark_as_important',
        {
            id: id,
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

    $('.autogrow').autogrow();

});
