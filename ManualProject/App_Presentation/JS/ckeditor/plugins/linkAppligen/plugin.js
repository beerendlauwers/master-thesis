CKEDITOR.plugins.add('linkAppligen',
{
    init: function(editor)
    {
        var pluginName = 'linkAppligen';
		var a= {
			exec:function(editor)
			{
				var theSelectedText = editor.getSelection().getNative();
			}
		}
        CKEDITOR.dialog.add( pluginName, this.path + 'dialogs/linkAppligen.js' );
		editor.addCommand( pluginName, new CKEDITOR.dialogCommand( pluginName ) );
        editor.ui.addButton('linkAppligen',
            {
                label: 'Image Toevoegen',
                command: pluginName,
				icon: this.path + 'images/view.png'
            });
    }
});