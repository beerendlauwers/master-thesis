function addToCartProxy(cid) {
 var spanid = 'cmsg_'+cid;
 DanaPutInnerHTML(document.getElementById(spanid) , "processing...",0);
 MetadataCartJS.addToCart(cid, {
  callback:function(data) {
   cartCallback(data,spanid);
  }
 });
}
function cartCallback(data, spanid) {
 DanaPutInnerHTML(document.getElementById(spanid) , data,0);
}
