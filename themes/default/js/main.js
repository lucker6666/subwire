/********************************************************
    vim: expandtab sw=4 ts=4 sts=4:
    -----------------------------------------------------
    Blip - Microblogging Platform
    By Kelli Shaver - kelli@kellishaver.com
    -----------------------------------------------------
    Blip is released under the Creative Commons
    Attribution, Non-Commercial, Share-Alike license.

    http://creativecommons.org/licenses/by-nc-sa/3.0/
    -----------------------------------------------------
    Blip Admin JavaScript
    -----------------------------------------------------
    JavaScript functions for the Blip admin interface.
********************************************************/
function nic_init() {
    new nicEditor({
        iconsPath:'images/nicEditorIcons.gif',
        buttonList:['bold','italic','underline','left','center','right','justify','ol','ul','indent','outdent','image','link','unlink', 'removeformat', 'hr']
    }).panelInstance('rte');
}

function toggleComment(element) {
    var commentDiv = $(element).parents('aside').siblings('div.newComment');
    var inputs = commentDiv.children().children('input');

    commentDiv.fadeIn(function() {
        inputs[0].focus();
    });

    inputs.keypress(function(e) {
        var keyCode = e.which ? e.which : e.keyCode;
        console.log(keyCode);

        if (keyCode == 13) {
            $(this).blur();
            $(this).parents('form').submit();
        }
    });
}

function toggleLastComments() {
    var navRight = $('nav .right');
    var commentContainer = $('div#lastComments');

    if (navRight.hasClass('active')) {
        commentContainer.slideUp(function() {    
            navRight.removeClass('active');
        });
    } else {
        navRight.addClass('active');
        commentContainer.slideDown();
    }
}

jQuery(function($) {
    setTimeout('$("#flash_error").fadeOut(1000)', 3000);
    setTimeout('$("#flash_notice").fadeOut(1000)', 3000);

    $('pre code').each(function(i, e) {hljs.highlightBlock(e, '    ')});

    $('.btn').button();

    if ($('#rte').length > 0) nic_init();

    $('.delete').click(function(e) {
        if(confirm("Are you sure you want to delete this post?")) return true;
        else return false;
    });

    $('.cancel').click(function(e) {
        e.preventDefault();
        this.parentNode.parentNode.reset();
    });
});

