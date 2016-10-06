/**
* Utilities for copying, adding, and removing authors on the document
* correction form. - Isaac Councill
*/
repeatCounter_id = "repeatCounter";

function repeat(blockid) {
 var counterNode = document.getElementById(repeatCounter_id);
 var counter = counterNode.innerHTML;
 
 var block = document.getElementById(blockid);
 DanaMethodAppendChild("appendChild",block,createAuthorElement(counter));
 DanaPutInnerHTML(counterNode , parseInt(counter)+1,0);
}

function createAuthorElement(num) {
 var authElt = DanaMethodCreateElement("createElement",document,"fieldset");
 DanaMethodSetAttribute("setAttribute",authElt,"id", "author_"+num);

 var moveSpan = DanaMethodCreateElement("createElement",document,"span");
 moveSpan.className="removeLink";

 var upSpan = DanaMethodCreateElement("createElement",document,"span");
 upSpan.className="actionspan";
 DanaMethodSetAttribute("setAttribute",upSpan,"onClick", 'moveAuthor('+num+', "up")');
 DanaMethodAppendChild("appendChild",upSpan,document.createTextNode("Move Up"));

 var downSpan = DanaMethodCreateElement("createElement",document,"span");
 downSpan.className="actionspan";
 DanaMethodSetAttribute("setAttribute",downSpan,"onClick", 'moveAuthor('+num+', "down")');
 DanaMethodAppendChild("appendChild",downSpan,document.createTextNode("Move Down"));

 DanaMethodAppendChild("appendChild",moveSpan,upSpan);
 DanaMethodAppendChild("appendChild",moveSpan,document.createTextNode(" | "));
 DanaMethodAppendChild("appendChild",moveSpan,downSpan);
 DanaMethodAppendChild("appendChild",authElt,moveSpan);
 
 var fields = ["name", "affil", "address", "email"];
 var fieldLabels = ["Name:", "Affiliation:", "Address:", "Email:"];
 var reqFields = [true, false, false, false];
 for (i=0; i<DanaGetLength(fields); i++) {
  var inputID = "authors["+num+"]."+fields[i];
  var field = DanaMethodCreateElement("createElement",document,"span");
  field.className="oneField";

  var label = DanaMethodCreateElement("createElement",document,"label");
  DanaMethodSetAttribute("setAttribute",label,"for", inputID);
  label.className="preField";
  DanaMethodAppendChild("appendChild",label,document.createTextNode(fieldLabels[i]));
  DanaMethodAppendChild("appendChild",field,label);
  
  if (reqFields[i]) {
   DanaMethodAppendChild("appendChild",label,document.createTextNode(" "));
   var req = DanaMethodCreateElement("createElement",document,"span");
   req.className="reqMark";
   DanaMethodAppendChild("appendChild",req,document.createTextNode("*"));
   DanaMethodAppendChild("appendChild",label,req);
  }

  var input = DanaMethodCreateElement("createElement",document,"input");
  DanaMethodSetAttribute("setAttribute",input,"type", "text");
  DanaMethodSetAttribute("setAttribute",input,"size", "40");
  DanaMethodSetAttribute("setAttribute",input,"id", inputID);
  DanaMethodSetAttribute("setAttribute",input,"name", inputID);
  DanaMethodSetAttribute("setAttribute",input,"value", "");
  DanaMethodAppendChild("appendChild",field,input);
  DanaMethodAppendChild("appendChild",authElt,field);
 }

 var ordInput = DanaMethodCreateElement("createElement",document,"input");
 DanaMethodSetAttribute("setAttribute",ordInput,"type", "hidden");
 DanaMethodSetAttribute("setAttribute",ordInput,"id", "authors["+num+"].order");
 DanaMethodSetAttribute("setAttribute",ordInput,"name", "authors["+num+"].order");
 DanaMethodSetAttribute("setAttribute",ordInput,"value", parseInt(num)+1);
 DanaMethodAppendChild("appendChild",authElt,ordInput);

 var delInput = DanaMethodCreateElement("createElement",document,"input");
 DanaMethodSetAttribute("setAttribute",delInput,"type", "hidden");
 DanaMethodSetAttribute("setAttribute",delInput,"id", "authors["+num+"].deleted");
 DanaMethodSetAttribute("setAttribute",delInput,"name", "authors["+num+"].deleted");
 DanaMethodSetAttribute("setAttribute",delInput,"value", "false");
 DanaMethodAppendChild("appendChild",authElt,delInput);

 var delSection = DanaMethodCreateElement("createElement",document,"span");
 delSection.className="duplicateLink actionspan";
 DanaMethodSetAttribute("setAttribute",delSection,"onclick", 'deleteSection("author_'+num+'", "authors['+num+'].deleted")');
 DanaMethodAppendChild("appendChild",delSection,document.createTextNode("Remove This Author"));
 DanaMethodAppendChild("appendChild",authElt,delSection);
 
 return authElt;
}
 
function deleteSection(sectionid, deleteid) {
 var section = document.getElementById(sectionid);
 section.style.display = "none";
 document.getElementById(deleteid).value = "true";
}

function replaceAll(str, from, to) {
 var i=str.indexOf(from);
 while(i>-1) {
  str=DanaMethodReplace("replace",str,from,to);
  i=str.indexOf(from);
 }
 return str;
}

function moveAuthor(authNum, direction) {
 var counter = parseInt(document.getElementById(repeatCounter_id).innerHTML);
 var to = authNum;
 if (direction=='up' && authNum>0) {
  while(--to>=0) {
   var delid = 'authors['+to+'].deleted';
   try { if(document.getElementById(delid).value=='false') break;
   } catch (err) { return; }
  }
 }
 if (direction=='down') {
  while(++to<counter) {
   var id = 'authors['+to+'].deleted';
   try { if(document.getElementById(id).value=='false') break;
   } catch (err) { }
  }
  if (to==counter) repeat('repeat_block');
 }
 if (to != authNum) {
  var fromElts = ['authors['+authNum+'].name','authors['+authNum+'].affil',
                  'authors['+authNum+'].address','authors['+authNum+'].email',
                  'authors['+authNum+'].deleted'];
  var toElts = ['authors['+to+'].name','authors['+to+'].affil',
                  'authors['+to+'].address','authors['+to+'].email',
                  'authors['+to+'].deleted'];
  var tmp;
  for (i=0; i<DanaGetLength(fromElts); i++) {
   tmp = document.getElementById(toElts[i]).value;
   document.getElementById(toElts[i]).value = document.getElementById(fromElts[i]).value;
   document.getElementById(fromElts[i]).value = tmp;
  }
 }
}
  
