CKEDITOR.plugins.add('imageAppligen',
{
    init: function(editor)
    {
        var pluginName = 'imageAppligen';
		var a= {
			exec:function(editor)
			{
				var theSelectedText = editor.getSelection().getNative();
			}
		}
        CKEDITOR.dialog.add( pluginName, this.path + 'dialogs/imageAppligen.js' );
		editor.addCommand( pluginName, new CKEDITOR.dialogCommand( pluginName ) );

        editor.ui.addButton('imageAppligen',
            {
                label: 'Imagelink Toevoegen',
                command: pluginName,
				icon: this.path + 'images/view.png'
            });
    }
});