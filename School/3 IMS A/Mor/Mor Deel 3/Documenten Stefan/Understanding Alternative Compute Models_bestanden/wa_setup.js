// wa_setup.js Version 4.0 - H Code
//  History */
// -------------------------------------
//  Added support for WAP 2.1 variables.
// -------------------------------------
//  Modified version to 2.2 - no changes made.
// -------------------------------------
//  Version 3.0 -  8 Sep 2006: Added wa_eVar11-15 (commented out - a future enhancement),
//  wa_eCustom21-35, wa_eCustom46-50. wa_custom46-50, wa_trackDownloads to support new capabilities
// -------------------------------------
// Version 3.1 - 27 Mar 2007 - Removed wa_eVar11-15 - not needed.
// No changes were needed for this release.
// -------------------------------------
// Version 3.2 - 27 July 2007 - Added wa_custom36-45, wa_eCustom36-45.
// -------------------------------------
// Version 4.0 - Dec 2008 - Added shopping cart vars, updated to H Code
// -------------------------------------


var wa_queryObj = waParseQueryString(location.search);

var	wa_pageName="",
	wa_org1="",
	wa_org2="",
	wa_org3="",
	wa_org4="",
	wa_orgX="",
	wa_geo="",
	wa_language="",
	wa_iid="",
	wa_reportSuites="",
	wa_url="",
	wa_ngipDocId="",
	wa_ngipUniqueId="",
	wa_campaign="",
	wa_events="",
	wa_custom01="",
	wa_custom02="",
	wa_custom03="",
	wa_custom04="",
	wa_custom05="",
	wa_custom06="",
	wa_custom07="",
	wa_custom08="",
	wa_custom09="",
	wa_custom10="",
	wa_custom11="",
	wa_custom12="",
	wa_custom13="",
	wa_custom14="",
	wa_custom15="",
	wa_custom36="",
	wa_custom37="",
	wa_custom38="",
	wa_custom39="",
	wa_custom40="",
	wa_custom41="",
	wa_custom42="",
	wa_custom43="",
	wa_custom44="",
	wa_custom45="",
	wa_custom46="",
	wa_custom47="",
	wa_custom48="",
	wa_custom49="",
	wa_custom50="",
	wa_eCustom21="",
	wa_eCustom22="",
	wa_eCustom23="",
	wa_eCustom24="",
	wa_eCustom25="",
	wa_eCustom26="",
	wa_eCustom27="",
	wa_eCustom28="",
	wa_eCustom29="",
	wa_eCustom30="",
	wa_eCustom31="",
	wa_eCustom32="",
	wa_eCustom33="",
	wa_eCustom34="",
	wa_eCustom35="",
	wa_eCustom36="",
	wa_eCustom37="",
	wa_eCustom38="",
	wa_eCustom39="",
	wa_eCustom40="",
	wa_eCustom41="",
	wa_eCustom42="",
	wa_eCustom43="",
	wa_eCustom44="",
	wa_eCustom45="",	
	wa_eCustom46="",
	wa_eCustom47="",
	wa_eCustom48="",
	wa_eCustom49="",
	wa_eCustom50="",	
	wa_visitId="",
	wa_referrer="",
	wa_profileID="",
	wa_products="",
	wa_purchaseID="",
	wa_pageType="",
	wa_intFilters="",
	wa_urlQueryString="",
	wa_trackMedia="",
	wa_trackDownloads="";


var wa_visitId = waGetCookie('wa_visitId');
if (wa_visitId == null)
{
	wa_visitId = waNewId();
}


waSetCookie('wa_visitId', wa_visitId);

function waParseQueryString(queryString)
{
	var queryObject = new Object();
	queryString = queryString.replace(/^.*\?(.+)$/,'$1');

	while ((pair = queryString.match(/([^=]+)=\'?([^\&\']*)\'?\&?/)) && pair[0].length)
	{
		queryString = queryString.substring( pair[0].length );
		//if (/^\-?\d+$/.test(pair[2])) pair[2] = parseInt(pair[2]);
		queryObject[pair[1]] = pair[2];
	}
	return queryObject;
}

function waNewId()
{
	var guid = "{";
	for (var i = 1; i <= 32; i++)
	{
		var n = Math.floor(Math.random() * 16.0).toString(16);
		guid += n;
		if ((i == 8) || (i == 12) || (i == 16) || (i == 20))
			guid += "-";
	}
	guid += "}";
	return guid;
}

function waGetCookie (name)
{
	var arg = name + "=";
	var alen = arg.length;
    var clen = document.cookie.length;
    var i = 0;
    while (i < clen)
    {
		var j = i + alen;
        if (document.cookie.substring(i, j) == arg)
			return waGetCookieVal (j);
        i = document.cookie.indexOf(" ", i) + 1;
        if (i == 0)
			break;
	}
	return null;

}

function waGetCookieVal (offset)
{
	var endstr = document.cookie.indexOf (";", offset);
	if (endstr == -1)
		endstr = document.cookie.length;
	return unescape(document.cookie.substring(offset, endstr));
}

function waSetCookie (name, value)
{
	var wa_cookieExpDate = new Date ();	
	wa_cookieExpDate.setTime(wa_cookieExpDate.getTime() + (365 * 24 * 3600 * 1000));
    document.cookie = name + "=" + escape (value) +
		"; expires=" + wa_cookieExpDate.toGMTString() +
		"; path=/" +
        "; domain=.intel.com"
       
}

function checkMeta(tagNameIn) {
	
  var metas = document.getElementsByTagName('META');
  var i;
  for (i = 0; i < metas.length; i++)
    if (metas[i].getAttribute('name') == tagNameIn)
		var tagNameValue = metas[i].getAttribute('content');		
		return tagNameValue;
		 
}
