$(document).ready(function() {

    $('[id^=mai-link]').click(function() {

        var is_important = $(this).attr('data-is-important') != 'true';
        var id = $(this).attr('data-id');

        $.post('/ajax/article/mark_as_important',
        {
            id: id,
            is_important: is_important
        },
        function() {

            if (!is_important)
                $('#mai-link-' + id).text('mark as important');
            else
                $('#mai-link-' + id).text('unmark important');

            $('#mai-link-' + id).attr('data-is-important', is_important);
        });
    });

});
