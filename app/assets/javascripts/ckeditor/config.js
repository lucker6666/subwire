CKEDITOR.editorConfig = function( config )
{
    config.toolbar = [
    	{ name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
    	{ name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock' ] },
    	{ name: 'links', items : [ 'Link','Unlink' ] },
    	{ name: 'insert', items : [ 'Image','Table','HorizontalRule' ] },
    	{ name: 'styles', items : [ 'Format','TextColor' ] },
    	{ name: 'tools', items : [ 'Maximize', 'ShowBlocks' ] }
    ];
};