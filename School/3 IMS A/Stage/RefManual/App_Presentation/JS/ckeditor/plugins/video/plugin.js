CKEDITOR.plugins.add('video',
{
    init: function(editor)
    {
        var pluginName = 'video';
		var a= {
			exec:function(editor)
			{
				var theSelectedText = editor.getSelection().getNative();
			}
		}
        CKEDITOR.dialog.add( pluginName, this.path + 'dialogs/video.js' );
		editor.addCommand( pluginName, new CKEDITOR.dialogCommand( pluginName ) );
        editor.ui.addButton('Video',
            {
                label: 'Video Toevoegen',
                command: pluginName,
				icon: this.path + 'images/view.png'
            });
    }
});