
CKEDITOR.dialog.add( 'linkAppligen', function( editor )
{

	var lblInfoTekst = '<br/><strong>OPMERKING:</strong> Als u deze link wil verplaatsen, dient u eerst<br/>'
					   + 'op de link te klikken, en hierna op het <strong>"a"</strong>-veldje te klikken in de onderste balk.'
					   + '<br/>Enkel dan zal de volledige link geselecteerd zijn,<br/> waarna u hem kan knippen en plakken naarwaar u wilt.<br/><br/>' 
					   + '<i>Voorbeeld van onderste balk:</i> <img style="vertical-align:middle;" src="' + CKEDITOR.plugins.getPath( 'linkAppligen' ) + 'images/infoelement.png" />';
			
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
		title : 'Link Toevoegen',
		minWidth : 300,
		minHeight : 400,
		onOk : function()
		{

			var txtVideoBox = document.getElementById('ArtikelKiezenWaarde').value;
			txtVideoBox = "page.aspx?id=" + txtVideoBox;
			
			element = editor.document.createElement( 'a' );
			element.setAttribute('href', txtVideoBox);
		
			var htmlwaarde = document.getElementById('ArtikelKiezenTekst').value;
			
			element.setHtml( htmlwaarde );

			var name =  'ImageAppligen_' + txtVideoBox;
	
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
				element.addClass( 'cke_imageAppligen' );
			else
				element.removeClass( 'cke_imageAppligen' );

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
			if ( element && element.getAttribute( '_cke_real_element_type' ) && element.getAttribute( '_cke_real_element_type' ) == 'linkAppligen' )
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
				label : 'Link Toevoegen',
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
										type : 'html',
										id : 'txtVideo',
										html: 'Paginanummer:<div class="cke_dialog_ui_input_text"><input type="text" class="cke_dialog_ui_input_text" value="Geen nummer" id="ArtikelKiezenWaarde" style="width:200px;"  /></div>'
									},
									{
										type : 'html',
										id : 'lblInfo',
										html : '<a href="#" onclick="window.open(\'' + CKEDITOR.basePath + 'ArtikelKiezen.aspx' + '\',\'mywindow\',\'status=1,width=470,height=400\');" class="cke_dialog_ui_button"><span class="cke_dialog_ui_button">Pagina Selecteren</span></a>'										
									}
								]
							},
							{
								type : 'hbox',
								children :
								[
									{
										type : 'html',
										id : 'txtTekst',
										html: 'Weer te geven tekst:<div class="cke_dialog_ui_input_text"><input type="text" class="cke_dialog_ui_input_text" value="" id="ArtikelKiezenTekst" style="width:350px;" /></div>'
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
