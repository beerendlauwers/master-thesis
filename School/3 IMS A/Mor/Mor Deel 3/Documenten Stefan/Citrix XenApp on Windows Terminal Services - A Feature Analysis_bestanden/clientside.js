<!--
var MM_contentVersion = 4;
var plugin = (navigator.mimeTypes && navigator.mimeTypes["application/x-shockwave-flash"]) ? navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin : 0;
if ( plugin ) {
		var words = navigator.plugins["Shockwave Flash"].description.split(" ");
	    for (var i = 0; i < words.length; ++i)
	    {
		if (isNaN(parseInt(words[i])))
		continue;
		var MM_PluginVersion = words[i]; 
	    }
	var MM_FlashCanPlay = MM_PluginVersion >= MM_contentVersion;
}
else if (navigator.userAgent && navigator.userAgent.indexOf("MSIE")>=0 
   && (navigator.appVersion.indexOf("Win") != -1)) {
	document.write('<SCR' + 'IPT LANGUAGE=VBScript\> \n'); //FS hide this from IE4.5 Mac by splitting the tag
	document.write('on error resume next \n');
	document.write('MM_FlashCanPlay = ( IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash." & MM_contentVersion)))\n');
	document.write('</SCR' + 'IPT\> \n');
}

function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}

function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}

// Note: Changes in this file below must be kept in lock step with changes in javascript_main.asp!!!
// File History
// 05/18/07 BR    Updated for flash upgrade project.

// Extend functionality in AC_RunActiveContent.js for Citrix site
function AC_FL_RunContent_NoFileExtension(){
  var ret = 
    AC_GetArgs
    (  arguments, "", "movie", "clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
     , "application/x-shockwave-flash"
    );
  AC_Generateobj(ret.objAttrs, ret.params, ret.embedAttrs);
}

function AC_FL_RunContent_Extended(objectId, width, height, filePath, flashVars, wMode, bgColor, useSSL) {
	var extSSL = (useSSL ? 's' : '');

	AC_FL_RunContent_NoFileExtension( 
		'codebase','http' + extSSL + '://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0',
		'id', objectId, 
		'FlashVars', flashVars,					// doubles as src query string attributes
		'width', width, 'height', height,		// end object attributes 
		'movie', filePath,						// doubles as embedded "src" attribute
		'menu', 'false',
		'quality', 'autohigh',
		'scale', 'exactfit',
		'salign', 'LT',
		'wmode', wMode,
		'bgcolor', bgColor,						// end parameters
		'swLiveConnect', 'FALSE', 
		'name', objectId,
		'pluginspage','http://www.macromedia.com/go/getflashplayer'
		  								// end embedded attributes
		 );
}

function AC_FL_RunContent_Express(objectId, width, height, filePath) {
		AC_FL_RunContent_Extended(objectId, width, height, filePath, '', 'opaque', '#FFFFFF', true);
}

function AC_FL_RunContent_Published(objectId, width, height, filePath) {
		AC_FL_RunContent_Extended(objectId, width, height, filePath, '', 'transparent', '#', true);
}

//-->

