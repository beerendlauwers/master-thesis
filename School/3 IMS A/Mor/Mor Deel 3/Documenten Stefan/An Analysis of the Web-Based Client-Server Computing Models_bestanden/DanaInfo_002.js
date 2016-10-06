/* Javascript for IE. It applies the 'sfhover' class to li elements in the 'nav' id'd ul element when they are 'moused over' and removes it, using a regular expression, when 'moused out'. */
sfHover = function() {
     var sfEls = document.getElementById("secondary_tabs").getElementsByTagName("LI");
     for (var i=0; i<DanaGetLength(sfEls); i++) {
         sfEls[i].onmouseover=function() {
             this.className+=" sfhover";         
		}         
		sfEls[i].onmouseout=function() {
             this.className=DanaMethodReplace("replace",this.className,new RegExp(" sfhover\\b"), "");
		}
     }
}
if (window.attachEvent) window.attachEvent("onload", sfHover); 