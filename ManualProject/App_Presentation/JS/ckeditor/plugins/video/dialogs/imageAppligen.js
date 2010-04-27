
CKEDITOR.dialog.add( 'imageAppligen', function( editor )
{

	var lblInfoTekst = '<br/><strong>OPMERKING:</strong> Als u deze imagelink wil verplaatsen, dient u eerst<br/>'
					   + 'op de link te klikken, en hierna op het <strong>"a"</strong>-veldje te klikken in de onderste balk.'
					   + '<br/>Enkel dan zal de volledige imagelink geselecteerd zijn,<br/> waarna u hem kan knippen en plakken naarwaar u wilt.<br/><br/>' 
					   + '<i>Voorbeeld van onderste balk:</i> <img style="vertical-align:middle;" src="' + CKEDITOR.plugins.getPath( 'imageAppligen' ) + 'images/infoelement.png" />';
			
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
		title : 'Image Toevoegen',
		minWidth : 300,
		minHeight : 400,
		onOk : function()
		{

			var txtVideoBox = this.getValueOf( 'info', 'txtVideo' );

			var relationship = 'shadowbox';
			
			if( this.getValueOf( 'info', 'txtHoogte' ) || this.getValueOf( 'info', 'txtBreedte' ) )
				relationship = relationship + ';';
			
			if( this.getValueOf( 'info', 'txtHoogte' ) )
			{
				relationship = relationship + 'height=' + this.getValueOf( 'info', 'txtHoogte' );
				if( this.getValueOf( 'info', 'txtBreedte' ) )
					relationship = relationship + ';';
			}
			
			if( this.getValueOf( 'info', 'txtBreedte' ) )
				relationship = relationship + 'width=' + this.getValueOf( 'info', 'txtBreedte' );
		
			element = editor.document.createElement( 'a' );
			element.setAttribute('href', txtVideoBox);
			element.setAttribute('rel', relationship );
		
			var htmlwaarde = this.getValueOf( 'info', 'txtTekst' ) + '<img border="0" src="CSS/images/imageicon.png" style="display:inline" />';
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
			if ( element && element.getAttribute( '_cke_real_element_type' ) && element.getAttribute( '_cke_real_element_type' ) == 'imageAppligen' )
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
				label : 'Image Toevoegen',
				accessKey : 'I',
				elements :
				[
					{
						type : 'vbox',
						padding : 0,
						children :
						[
							{
								type : 'hbox',
								widths : [ '280px', '110px' ],
								align : 'right',
								children :
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
												alert( 'Gelieve een videobestand op te geven.' );
												return false;
											}
											return true;
										}
									},
									{
										type : 'button',
										id : 'btnSelecteerBestand',
										style : 'display:inline-block;margin-top:10px;',
										label : 'Bestand Kiezen',
										filebrowser :
										{
											action : 'Browse',
											target : 'info:txtVideo'
										}
									}
								]
							},
							{
								type : 'hbox',
								widths : [ '50%', '50%' ],
								children :
								[
									{
										type : 'text',
										id : 'txtHoogte',
										label : 'Hoogte'
									},
									{
										type : 'text',
										id : 'txtBreedte',
										label : 'Breedte'
									}
								]
							},
							{
								type : 'hbox',
								children :
								[
									{
										type : 'text',
										id : 'txtTekst',
										label : 'Weer te geven tekst',
										required: true,
										validate : function()
										{
											if ( !this.getValue() )
											{
												alert( 'Gelieve tekst in te vullen.' );
												return false;
											}
											return true;
										}
									}
								]
							},
							{
								type : 'hbox',
								children :
								[
									{
										type : 'html',
										id : 'lblInfo',
										style : 'width:300px;',
										html : lblInfoTekst
									}
								]
							}
						]
					}
				]
			}
		]
	};
} );
