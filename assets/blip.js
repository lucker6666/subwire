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
    Blip Default Theme JavaScript
    -----------------------------------------------------
    JavaScript functions for the client-side default
    Blip theme.
********************************************************/
jQuery(function($) {
    // Enable syntax highlighting.
    $('pre code').each(function(i, e) {hljs.highlightBlock(e, '    ')});
});

