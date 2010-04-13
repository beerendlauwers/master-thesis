
CKEDITOR.dialog.add( 'video', function( editor )
{

	var lblInfoTekst = '<strong>OPMERKING:</strong> Als u deze videolink wil verplaatsen, dient u eerst<br/>'
					   + 'op de link te klikken, en hierna op het <strong>"a"</strong>-veldje te klikken (voorbeeld hieronder).'
					   + '<br/>Enkel dan zal de volledige videolink geselecteerd zijn,<br/> waarna u hem kan knippen en plakken naarwaar u wilt.<br/>' 
					   + '<i>Voorbeeld:</i> <img style="vertical-align:middle;" src="' + CKEDITOR.plugins.getPath( 'video' ) + 'images/infoelement.png" />';
			
	// Function called in onShow to load selected element.
	var loadElements = function( editor, selection, element )
	{
		this.editMode = true;
		this.editObj = element;

		var attributeValue = this.editObj.getAttribute( 'name' );
		if ( attributeValue )
			this.setValueOf( 'info','txtVideo', attributeValue );
		else
			this.setValueOf( 'info','txtVideo', "" );
	};

	return {
		title : 'Video Toevoegen',
		minWidth : 300,
		minHeight : 60,
		onOk : function()
		{

			var txtVideoBox = this.getValueOf( 'info', 'txtVideo' );
		
			element = editor.document.createElement( 'a' );
			element.setAttribute('href', txtVideoBox);
			element.setAttribute('rel', 'shadowbox');
		
			var htmlwaarde = this.getValueOf( 'info', 'txtTekst' ) + '<img border="0" src="CSS/images/view.png" style="display:inline" />';
			element.setHtml( htmlwaarde );

			var name =  'Video_' + txtVideoBox;
	
			// Move contents and attributes of old video to new video.
			if ( this.editMode )
			{
				this.editObj.copyAttributes( element, { name : 1 } );
				this.editObj.moveChildren( element );
			} 

			// Set name.
			element.removeAttribute( '_cke_saved_name' );
			element.setAttribute( 'name', name );
			
			if ( element.getAttribute( 'name' ) )
				element.addClass( 'cke_video' );
			else
				element.removeClass( 'cke_video' );

			// Insert a new video.
			if ( !this.editMode )
			{
				editor.insertElement( element );
			}
			else
			{
				element.replace( this.fakeObj );
				editor.getSelection().selectElement( element );
			}

			return true;
		},
		onShow : function()
		{
			this.editObj = false;
			this.fakeObj = false;
			this.editMode = false;

			var selection = editor.getSelection();
			var element = selection.getSelectedElement();
			if ( element && element.getAttribute( '_cke_real_element_type' ) && element.getAttribute( '_cke_real_element_type' ) == 'video' )
			{
				this.fakeObj = element;
				element = editor.restoreRealElement( this.fakeObj );
				loadElements.apply( this, [ editor, selection, element ] );
				selection.selectElement( this.fakeObj );
			}
			this.getContentElement( 'info', 'txtVideo' ).focus();
		},
		contents : [
			{
				id : 'info',
				label : 'Video Toevoegen',
				accessKey : 'I',
				elements :
				[
					{
						type : 'text',
						id : 'txtVideo',
						label : 'Videobestand',
						required: true,
						validate : function()
						{
							if ( !this.getValue() )
							{
								alert( 'Gelieve een geldige waarde in te geven!' );
								return false;
							}
							return true;
						}
					},
					{
						type : 'button',
						id : 'btnSelecteerBestand',
						label : 'Bestand Kiezen',
						filebrowser :
						{
							action : 'Browse',
							target : 'info:txtVideo'
						}
					},
					{
						type : 'text',
						id : 'txtTekst',
						label : 'Weer te geven tekst',
						required: true,
						validate : function()
						{
							if ( !this.getValue() )
							{
								alert( 'Gelieve een geldige waarde in te geven!' );
								return false;
							}
							return true;
						}
					},
					{
						type : 'html',
						id : 'lblInfo',
						style : 'width:300px;',
						html : lblInfoTekst
					}
				]
			}
		]
	};
} );
