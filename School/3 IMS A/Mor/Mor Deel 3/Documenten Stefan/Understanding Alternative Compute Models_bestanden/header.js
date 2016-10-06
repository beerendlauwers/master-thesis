//
//  Intel header.js
//  v1.4 22/12/08
//

// namespace
if (typeof HAT == "undefined" || !HAT) {
    var HAT = {};
}

// initiate header functionality
HAT.SetUp =
{
    Main: function() {
        if (window.attachEvent) {
            window.attachEvent("onload", this.pageInit);
            window.attachEvent("onresize", this.pageResize);
            window.attachEvent("onscroll", this.pageResize);
        }
        else if (window.addEventListener) {
            window.addEventListener("load", this.pageInit, false);
            window.addEventListener("resize", this.pageResize, false);
            window.addEventListener("scroll", this.pageResize, false);
        }
    },
    pageInit: function() {
        if (!document.getElementById("HAT-globalheader")) { return false; }
        if (!document.getElementById("HAT-subheader")) { return false; }
        HAT.SectionHighlighting.Global();
        HAT.SectionHighlighting.Sub();
        HAT.DropdownMenus.PositionMenus();
        HAT.DropdownMenus.AttachEvents();
        HAT.FilterMenu.BuildFilter();
        HAT.FilterMenu.AttachEvents();
        HAT.Form.AttachEvents();
        HAT.BackgroundImage.changeBodyClass();
        HAT.PopupWindow.attachEvents();
        HAT.Helper.changeHrefsToRel();

    },
    pageResize: function() {
        if (!document.getElementById("HAT-globalheader")) { return false; }
        if (!document.getElementById("HAT-subheader")) { return false; }
        HAT.DropdownMenus.PositionMenus();
    }
}
// kick off here
HAT.SetUp.Main();

// Section Heighlighting in the header
HAT.SectionHighlighting =
{
    _pagePath: document.location.pathname,
    _highlightClass: " on",
    Global: function() {
        var subheaderClassName = document.getElementById("HAT-subheader").className;
        var globalSectionId = subheaderClassName.replace(/.*subheaderId-HAT-gh(\d+).*/, "HAT-gh$1");
        var tmpUrlLength = null;
        if (HAT.ControlPanel && (HAT.ControlPanel.lightGlobalHeaderSection != null)) {
            globalSectionId = "HAT-gh" + HAT.ControlPanel.lightGlobalHeaderSection
        }
        for (var i = 0; i < HAT.GlobalheadingLUT.sub.length; i++) {
            for (var j = 0; j < HAT.GlobalheadingLUT.sub[i].path.length; j++) {
                if (this._pagePath.indexOf(HAT.GlobalheadingLUT.sub[i].path[j].value) != -1) {
                    var tmpPath = this._pagePath;
                    tmpPath = tmpPath.replace(HAT.GlobalheadingLUT.sub[i].path[j].value, "");

                    if (tmpPath.length < tmpUrlLength || tmpUrlLength == null) {
                        globalSectionId = (HAT.GlobalheadingLUT.sub[i].id);
                    }
                    tmpUrlLength = tmpPath.length;
                }
            }
        }
        this.doHighlight(globalSectionId)
    },
    Sub: function() {
        var subSectionId = [];
        if (HAT.ControlPanel && (HAT.ControlPanel.lightSubHeaderSection != null)) {
            subSectionId = "HAT-sh" + HAT.ControlPanel.lightSubHeaderSection
        }
        else {
            this._pagePath = this._pagePath.replace(/^\/((\w{2}\/)?(\w{2}_\w{2}|apac|emea))(.*?)/, "$2");

            for (var i = 0; i < HAT.SubheadingLUT.sub.length; i++) {
                for (var j = 0; j < HAT.SubheadingLUT.sub[i].path.length; j++) {
                    this._pagePath = this._pagePath.toLowerCase();
                    if (HAT.SubheadingLUT.sub[i].path[j] && this._pagePath.indexOf(HAT.SubheadingLUT.sub[i].path[j].value.toLowerCase()) != -1) {
                        subSectionId.push(HAT.SubheadingLUT.sub[i].id)
                    }
                }
            }
        }
        this.doHighlight(subSectionId)
    },
    doHighlight: function(Id) {
        if (Id instanceof Array) {
            for (var i = 0; i < Id.length; i++) {
                if (document.getElementById(Id[i])) {
                    document.getElementById(Id[i]).getElementsByTagName("a")[0].className += this._highlightClass;
                }
            }
        } else {
            if (document.getElementById(Id)) {
                document.getElementById(Id).getElementsByTagName("a")[0].className += this._highlightClass;
            }
        }
    }
}

// Dropdown menus done here
HAT.DropdownMenus = {
    _activeMenuId: null, // records the active dropdown menu
    _pageWidth: 0,
    _menuIDs: new Array(), // count the dropdown menues
    _addMenuID: function(id) {
        HAT.DropdownMenus._menuIDs[HAT.DropdownMenus._menuIDs.length] = id;
    },
    AttachEvents: function() {
        var HatFilterTO = false;
        var objLIs = document.getElementById("HAT-subheader").getElementsByTagName("li");
        for (var i = 0; i < objLIs.length; i++) {
            var objULs = objLIs[i].getElementsByTagName("ul")
            // only set up for a dropdown if there is a sub-level UL.
            if (objULs.length > 0) {
                // place the iFrame shim  for I.E. <select> z-index fix
                if (navigator.appVersion.toLowerCase().indexOf("msie") != -1 && navigator.appVersion.substr(22, 3) <= 6) {

                    if (document.createStyleSheet) {
                        var _newStyleSheet = document.createStyleSheet();
                        _newStyleSheet.addRule("#HAT-subheader iframe", "position:absolute;top:0;left:0;filter:progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0");
                        for (var j = 0; j < objULs.length; j++) {

                            var ieShim = document.createElement('iframe');
                            ieShim.src = "javascript:false";

                            ieShim.scrolling = "no";
                            ieShim.id = "HAT-iframe" + j;
                            ieShim.frameBorder = "0";
                            ieShim.style.width = objULs[j].offsetWidth + "px";
                            ieShim.style.height = objULs[j].offsetHeight + "px";
                            ieShim.style.zIndex = "-1";
                            objULs[j].insertBefore(ieShim, objULs[j].childNodes[0]);
                            objULs[j].style.zIndex = "101";
                        }
                    }
                }
                // attach event listeners
                objLIs[i].onmouseover = function() {
                    if (HatFilterTO) {
                        clearTimeout(HatFilterTO);
                    }
                    HAT.DropdownMenus._activeMenuId = this.id;
                    HAT.DropdownMenus.clearAllDropDowns()
                    if (this.className.indexOf("sfhover") == -1) { this.className += " sfhover"; }
                    if (this.getElementsByTagName("iframe")[0]) {
                        this.getElementsByTagName("iframe")[0].style.visibility = "visible";
                    }
                    this.getElementsByTagName("ul")[0].style.top = '43px';
                }
                objLIs[i].onfocus = function() {
                    this.onmouseover();
                }
                objLIs[i].onmouseout = function() {
                    HatFilterTO = setTimeout("HAT.DropdownMenus.dropDownHide('" + this.id + "')", 200);
                }
                objLIs[i].onblur = function() {
                    this.onmouseout();
                }
                HAT.DropdownMenus._addMenuID(objLIs[i].id);
            }
        }
    },
    PositionMenus: function() {
        // test for page width overflow and adjust dropdown position
        var pageWidth = document.documentElement.clientWidth;
        if (pageWidth == 0 || pageWidth == null) {
            pageWidth = document.body.clientWidth
        }
        var liCollection = document.getElementById("HAT-subheader").getElementsByTagName("li")
        for (var i = 0; i < liCollection.length; i++) {
            var ulCollection = liCollection[i].getElementsByTagName("ul")
            if (ulCollection.length > 0) {
                var objDropdown = liCollection[i].getElementsByTagName("ul")[0]
                objDropdown.removeAttribute("style");
                var iDropDownWidth = objDropdown.offsetWidth;
                var scrollLeft = HAT.Helper.getScrollXY()[0];
                var iDropDownStart = liCollection[i].offsetLeft + liCollection[i].offsetParent.offsetLeft + 6 - scrollLeft;
                if ((pageWidth - iDropDownStart) < iDropDownWidth) {
                    objDropdown.style.left = (((pageWidth - iDropDownWidth) - iDropDownStart) + 5) + "px";
                }
            }
        }
    },
    dropDownHide: function(id) {
        var obj = document.getElementById(id)
        obj.className = obj.className.replace(new RegExp("\\bsfhover\\b"), "");
        if (obj.getElementsByTagName("iframe")[0]) {
            obj.getElementsByTagName("iframe")[0].style.visibility = "hidden";
        }
        if (obj.getElementsByTagName("ul")[0]) { obj.getElementsByTagName("ul")[0].style.top = '-9999px'; }
    },
    clearAllDropDowns: function() {
        for (var j = 0; j < HAT.DropdownMenus._menuIDs.length; j++) {
            var id = HAT.DropdownMenus._menuIDs[j];
            if (id != this._activeMenuId) {
                HAT.DropdownMenus.dropDownHide(id)
            }
        }
    }
}

// filter menu controls
HAT.FilterMenu = {
    BuildFilter: function() {
        if (HAT.SearchFilterLUT && HAT.SearchFilterLUT.qs.length > 0) {
            var menuUL = document.createElement("ul");
            menuUL.setAttribute("id", "HAT-filter-menu");
            var menuLI = document.createElement("li");
            menuLI.setAttribute("id", "HAT-filterhead");
            menuLI.innerHTML = HAT.SearchFilterLUT.head;
            menuUL.appendChild(menuLI);
            for (var j = 0; j < HAT.SearchFilterLUT.qs.length; j++) {
                var menuLI = document.createElement("li");
                var menuA = document.createElement("a");
                menuA.setAttribute("href", "?" + HAT.SearchFilterLUT.qs[j].filter);
                menuA.innerHTML = HAT.SearchFilterLUT.qs[j].term;


                menuLI.appendChild(menuA);
                menuUL.appendChild(menuLI);
            }
            document.getElementById("HAT-globalheader").appendChild(menuUL);
        }

        if (document.getElementById("HAT-filter-menu")) {
            var objFilterTrigger = document.getElementById("searchsubmit")
            var objFilterMenu = document.getElementById("HAT-filter-menu")
        }


        if (navigator.appVersion.toLowerCase().indexOf("msie") != -1 && navigator.appVersion.substr(22, 3) <= 6) {
            //ie shim
            if (document.createStyleSheet) {
                var _newStyleSheet = document.createStyleSheet();
                _newStyleSheet.addRule("#HAT-globalheader iframe", "position:absolute;top:0;left:0;filter:progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0");

                var ieShim = document.createElement('iframe');
                ieShim.src = "javascript:false";

                ieShim.scrolling = "no";
                ieShim.id = "HAT-iframeFilter";
                ieShim.frameBorder = "0";
                objFilterMenu.style.display = "block";
                ieShim.style.width = objFilterMenu.offsetWidth + "px";
                ieShim.style.height = objFilterMenu.offsetHeight + "px";
                objFilterMenu.style.display = "";
                ieShim.style.zIndex = "-1";
                objFilterMenu.insertBefore(ieShim, objFilterMenu.childNodes[0]);
                objFilterMenu.style.zIndex = "101";
            }
        }
    },
    AttachEvents: function() {
        var HatFilterTO = false;
        function getTrueOffsetLeft(o, total) {
            if (o.parentNode) {
                return getTrueOffsetLeft(o.parentNode, total + o.offsetWidth);
            } else {
                return total;
            }
        }
        if (document.getElementById("HAT-filter-menu")) {
            var objFilterTrigger = document.getElementById("searchsubmit")
            var objFilterMenu = document.getElementById("HAT-filter-menu")

            objFilterTrigger.onmouseover = function() {
                if (HatFilterTO) {
                    clearTimeout(HatFilterTO);
                }
                var objHatGlobalHeader = document.getElementById("HAT-globalheader");
                var pageWidth = document.documentElement.clientWidth;
                var leftOffset = 0;
                var left = 0;
                var top = 0;

                if (pageWidth == 0 || pageWidth == null) {
                    pageWidth = document.body.clientWidth
                }
                if (objFilterTrigger.getBoundingClientRect) {
                    var obj = objFilterTrigger.getBoundingClientRect();
                    var scrollLeft = HAT.Helper.getScrollXY()[0];
                    left = obj.left - 2 + scrollLeft;
                    top = obj.top - 2;
                } else {
                    if (document.body.className.indexOf("HAT-wide") != -1) {
                        if (pageWidth > objHatGlobalHeader.offsetWidth) { leftOffset = ((pageWidth - objHatGlobalHeader.offsetWidth) / 2); }
                    }
                    left = objFilterTrigger.offsetLeft + leftOffset;
                    top = objFilterTrigger.offsetTop;
                }
                if (!(objHatGlobalHeader.className.indexOf("HAT-rtl") >= 0)) {
                    left = left - 113;
                }
                if (navigator.appVersion.toLowerCase().indexOf("msie") != -1 && objHatGlobalHeader.className.indexOf("HAT-rtl") != -1) {
                    left = left - 137; //137
                }
                var objectWidth = document.getElementById('HAT-filter-menu').offsetWidth;

                objFilterMenu.style.left = (left) + "px";
                objFilterMenu.style.top = (top) + "px";
                if (objFilterMenu.className != "filterHover") { objFilterMenu.className = "filterHover" };
                if (navigator.appVersion.toLowerCase().indexOf("msie") != -1 && navigator.appVersion.substr(22, 3) <= 6) { document.getElementById("HAT-globalheader").getElementsByTagName("a")[0].style.position = 'absolute'; }
            }
            objFilterTrigger.onfocus = function() {
                this.onmouseover();
            }
            objFilterTrigger.onmouseout = function() {
                HatFilterTO = setTimeout("HAT.FilterMenu.dropDownHide()", 200);
            }
            objFilterTrigger.onblur = function() {
                this.onmouseout();
            }
            objFilterMenu.onmouseover = objFilterTrigger.onmouseover;
            objFilterMenu.onmouseout = objFilterTrigger.onmouseout;

            // attach events to the filter items
            var objFilterMenuItems = objFilterMenu.getElementsByTagName("a");
            for (var i = 0; i < objFilterMenuItems.length; i++) {
                objFilterMenuItems[i].onclick = function() {
                    HAT.FilterMenu.PostForm(this);
                    return (false);
                }
            }
            if (document.FORMSearchHeader.category) {
                document.FORMSearchHeader.category.value = "all";
            }
            if (document.FORMSearchHeader.adv) {
                document.FORMSearchHeader.adv.value = "0";
            }
            if (document.FORMSearchHeader.value) {
                document.FORMSearchHeader.value.value = "0";
            }
        }
    },
    PostForm: function(objLink) {
        var filterText = objLink.href.substring(objLink.href.indexOf("?") + 1);
        //special logic for Advanced search
        if (filterText != "HAT-adv1") {
            document.FORMSearchHeader.category.value = filterText;
        }
        else {
            document.FORMSearchHeader.adv.value = '1';
        }

        var culture = document.FORMSearchHeader.culture.value;
        if (culture === "ja_JP") {
            HAT.Form.EncodeSearchText("ja_JP")
        }
        else {
            document.FORMSearchHeader.submit();
        }
        return (false);
    },
    dropDownHide: function() {
        var objFilterMenu = document.getElementById("HAT-filter-menu")
        objFilterMenu.className = "filterHidden";
    }
}

// body tag rewrite - appends class attribute according screen size and protocol
HAT.BackgroundImage = {
    _pagePath: document.location.pathname,
    changeBodyClass: function() {
        /*
        HAT-narrowbg
        HAT-widebg
        HAT-narrowbg-secure
        HAT-widebg-secure
        */
        var isCombinedBg = -1;
        if (HAT.CombinedBackground) {
            for (var i = 0; i < HAT.CombinedBackground.sub.length; i++) {
                for (var j = 0; j < HAT.CombinedBackground.sub[i].path.length; j++) {
                    if (this._pagePath.indexOf(HAT.CombinedBackground.sub[i].path[j].value) != -1) {
                        isCombinedBg = 1;
                    }
                }
            }
        }

        var isWide = document.getElementById("HAT-globalheader").className.indexOf("HAT-wide");
        var isSecure = document.getElementById("HAT-globalheader").className.indexOf("HAT-secure");
        var isLocal = document.getElementById("HAT-globalheader").className.indexOf("HAT-rel");
        var newStyles = " ";

        if (isWide != -1 && isSecure == -1) {
            newStyles += ' HAT-widebg';
        }
        else if (isWide != -1 && isSecure != -1) {
            newStyles += ' HAT-widebg-secure';
        }
        else if (isWide == -1 && isSecure != -1) {
            newStyles += ' HAT-narrowbg-secure';
        }
        else {
            newStyles += ' HAT-narrowbg';
        }

        if (isWide != -1 && isLocal != -1) {
            newStyles += ' HAT-widebg-rel';
        }
        else if (isWide == -1 && isLocal != -1) {
            newStyles += ' HAT-narrowbg-rel';
        }

        if (isCombinedBg != -1) {
            newStyles = ' HAT-combinedBg';
        }

        document.getElementsByTagName("body")[0].className += newStyles;
    }
}

HAT.PopupWindow = {
    attachEvents: function() {
        var links = document.getElementsByTagName('a');
        for (var i = 0; i < links.length; i++) {
            if (links[i].className.indexOf("HAT-popup") != -1) {
                links[i].onclick = this.openPopup;
            }
        }
    },
    openPopup: function() {
        //Finds the parameter value
        function getParamValue(popupURL, parameterName) {
            var regexS = "[\\?&]" + parameterName + "=([^&#]*)";
            var regex = new RegExp(regexS);
            var results = regex.exec(popupURL);
            if (results == null) { return null; } else { return results[1]; }
        }

        var popupWidth = getParamValue(this.href, "HATpopupWidth");
        if (popupWidth == null) { popupWidth = (document.getElementById("HAT-globalheader").className.indexOf("HAT-wide") != -1) ? 1024 : 800; }

        var popupHeight = getParamValue(this.href, "HATpopupHeight");
        if (popupHeight != null) { popupHeight = ", height=" + popupHeight; }

        window.open(this.href, "popup", "width=" + popupWidth + popupHeight);
        return false;
    }
}


HAT.Helper = {
    /* Test domain list */
    CreateJSObject: function(url, appendTo) {
        var scriptObj = document.createElement("script");
        scriptObj.setAttribute("type", "text/javascript");
        scriptObj.setAttribute("src", url);
        appendTo.appendChild(scriptObj);
    },
    changeHrefsToRel: function() {
        var testURLlist = new Array("int-30recode.dev.mrmpweb.co.uk", "staging2.mrmpweb.co.uk", "proto-cps.cps.intel.com", "preview-cps.cps.intel.com");
        if (this.isInArray(testURLlist, document.location.host)) {
            var checkDiv = new Array("HAT-globalheader", "HAT-subheader", "HAT-unifiedfooter");
            for (var j = 0; j < checkDiv.length; j++) {
                if (document.getElementById(checkDiv[j])) {
                    var links = document.getElementById(checkDiv[j]).getElementsByTagName("a");
                    for (var i = 0; i < links.length; i++) {
                        links[i].href = links[i].href.replace(/http:\/\/www.intel.com/gi, '');
                        links[i].href = links[i].href.replace(/http:\/\/www.intel.co.jp/gi, '');
                    }
                }
            }
        }
    },
    getScrollXY: function() {
        var scrOfX = 0, scrOfY = 0;
        if (typeof (window.pageYOffset) == 'number') {
            //Netscape compliant
            scrOfY = window.pageYOffset;
            scrOfX = window.pageXOffset;
        } else if (document.body && (document.body.scrollLeft || document.body.scrollTop)) {
            //DOM compliant
            scrOfY = document.body.scrollTop;
            scrOfX = document.body.scrollLeft;
        } else if (document.documentElement && (document.documentElement.scrollLeft || document.documentElement.scrollTop)) {
            //IE6 standards compliant mode
            scrOfY = document.documentElement.scrollTop;
            scrOfX = document.documentElement.scrollLeft;
        }
        return [scrOfX, scrOfY];
    },
    debug: function(debug) {
        if (typeof (console) == 'object') {
            console.log(debug);
        }
        else {
            alert(debug);
        }
    },
    isInArray: function(arr, val) {
        var i;
        for (i = 0; i < arr.length; i++) {
            if (arr[i] === val) {
                return true;
            }
        }
        return false;
    }
}

/* encodes japanese charecters for search */
HAT.Form = {
    AttachEvents: function() {
        var culture = document.FORMSearchHeader.culture.value;
        if (culture == "ja_JP") {
            document.FORMSearchHeader.onsubmit = function() {
                HAT.Form.EncodeSearchText("ja_JP")
                return false;
            }
        }
    },
    EncodeSearchText: function(culture) {
        var adrs = document.FORMSearchHeader.action;
        var category = document.FORMSearchHeader.category.value;
        var adv = document.FORMSearchHeader.adv.value;
        var value = document.FORMSearchHeader.value.value;
        window.location = adrs + '?culture=' + culture + '&q=' + encodeURIComponent(document.FORMSearchHeader.q.value) + '&category=' + category + '&adv=' + adv + '&value=' + value;

    }
}

HAT.SubheadingLUT = {
    sub: [
      {
          id: 'HAT-sh-wiy',
          path: [
          { value: '/consumer/media/' },
          { value: '/consumer/inside/' },
          { value: '/consumer/index' }
        ]
      },
      {
          id: 'HAT-sh-wiyUS',
          path: [
          { value: '/consumer/media/' },
          { value: '/consumer/inside/' }
        ]
      },
      {
          id: 'HAT-sh-prod',
          path: [
          { value: '/products/services/' },
          { value: '/software/products/' },
          { value: '/design/embedded/' },
          { value: '/intel/technology-leadership/' },
          { value: '/products/' }
        ]
      },
      {
          id: 'HAT-sh-learn',
          path: [
          { value: '/consumer/learn/' }
        ]
      },
      {
          id: 'HAT-sh-tech',
          path: [
          { value: '/corporate/techtrends/' },
          { value: '/technology/' },
          { value: '/idf/' },
          { value: 'intel/enhancinglives/' },
          { value: '/corporate/europe/' },
          { value: '/corporate/education/' },
          { value: '/intel/environment/' },
          { value: '/intel/citizenship/' },
          { value: '/healthcare/' },
          { value: '/intel/worldahead/' },
          { value: '/standards/' },
          { value: '/intel/corpresponsibility/' },
          { value: '/intel/finance/' },
          { value: '/community/' }
        ]
      },
      {
          id: 'HAT-sh-shop',
          path: [
          { value: '/consumer/shop/' },
        ]
      },
      {
          id: 'HAT-sh-communities',
          path: [
          { value: '/communities/' },
          { value: '/intel/companyinfo/' },
          { value: '/intel/diversity/' },
          { value: '/intel/company/' },
          { value: '/capital/' },
          { value: '/museum/' },
          { value: '/jobs/' },
          { value: '/pressroom/' },
          { value: '/communities/index' }
        ]
      },
      {
          id: 'HAT-sh-game',
          path: [

          { value: '/consumer/game/' }
        ]
      },
      {
          id: 'HAT-sh-downloads',
          path: [
        ]
      },
      {
          id: 'HAT-sh-reseller',
          path: [
            { value: '/channel/reseller/' },
            { value: '/channel/distributor/' },
            { value: '/software/partner/' }
        ]
      },
      {
          id: 'HAT-sh-chome',
          path: [
            { value: '/consumer/index' }
        ]
      }
    ]
};
HAT.GlobalheadingLUT = {
    sub: [
      {
          /*work*/
          id: 'HAT-gh0',
          path: [
        ]
      },
      {
          /*play*/
          id: 'HAT-gh1',
          path: [
          { value: '/consumer/inside/' }
        ]
      },
      {
          /*support*/
          id: 'HAT-gh2',
          path: [
          { value: '/support/' },
          { value: '/services/' }
        ]
      },
      {
          /*about*/
          id: 'HAT-gh3',
          path: [
          { value: '/inside/' },
          { value: '/community/' },
          { value: '/corporate/' },
          { value: '/education/' },
          { value: '/events/' },
          { value: '/intel/' },
          { value: '/intelpress/' },
          { value: '/jobs/' },
          { value: '/museum/' },
          { value: '/news/' },
          { value: '/policy/' },
          { value: '/pressroom/' }
        ]
      },
      {
          id: 'HAT-gh4',
          path: [
          { value: '/intel/nav/' }
        ]
      }
    ]
};


// Control panel for header - can be placed anywhere in the page body.
HAT.ControlPanel = {
//lightGlobalHeaderSection : 1, // override Global header highlighting
//lightSubHeaderSection : 1 // override sub-header highlighting
}


//empty sectionOn function, so pages like http://www.intel.com/products/desktop/motherboard/index.htm?iid=desktop_body+board won't brake
function sectionOn() { }
function hideAllMenus() { }
function writeMenus() { }