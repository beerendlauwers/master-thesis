/* Copyright 2000-2003 Juniper Networks, Inc. All rights reserved.

   Warning: This computer program is protected by patent, copyright law
   and international treaties. Unauthorized reproduction or distribution
   of this program, or any portion of it, may result in severe civil and
   criminal penalties, and will be prosecuted to the maximum extent
   possible under the law.

   US Patent Pending
*/
var timesessiontop;
if(typeof(top)!="undefined"&&typeof(top.DStimediff)!="undefined") {
timesessiontop=top;
}else {
if(window.opener&&typeof(window.opener.top)!="undefined"&&typeof(window.opener.top)!="unknown"&&typeof(window.opener.top.DStimediff)!="undefined") {
timesessiontop=window.opener.top;
}
}
function getIVEHostname()
{
var r;
if(typeof(document.DSHost)!="undefined") r=document.DSHost;
else if(typeof(DSHost)!="undefined") r=DSHost;
if(typeof(r)!="undefined") {
var portstart=r.indexOf(':');
if(portstart!=-1) {
return r.substring(0, portstart);
}
return r;
}
return location.hostname;
}
function getCookieVal (offset) {  
var endstr=document.cookie.indexOf (";", offset);
if(endstr==-1)    
endstr=document.cookie.length;
return unescape(document.cookie.substring(offset, endstr));
}
function dsGetLastAccess() {
var img=new Image();
img.src='https://'+getIVEHostname()+'/dana/home/norefr.cgi';
}
function dsgetCookieVal(arg) 
{
var alen=arg.length;
var clen=document.cookie.length;
var i=0;
while(i<clen) {    
var j=i+alen;
if(document.cookie.substring(i, j)==arg) {
return getCookieVal (j);
}
i=document.cookie.indexOf(" ", i)+1;
if(i==0) break;
}  
return null;
}
function dsCheckTimeout(timeout, access, timediff) 
{
var dc=document.cookie;
var prefix="DSID=";
var begin=dc.indexOf("; "+prefix);
var foundDSID=1;
var DSID;
if(begin==-1) {
begin=dc.indexOf(prefix);
if(begin==-1) {
foundDSID=0;
}
}else begin+=2;
if(foundDSID) {
var end=document.cookie.indexOf(";", begin);
if(end==-1) {
end=dc.length;
}
DSID=dc.substring(begin+prefix.length, end);
}
if(typeof(DSID)=="undefined") {
return 0;
}
var curdate=new Date();
var curtime=parseInt(""+curdate.getTime()/1000);
var offset= 30;
var curtimeout=curtime+timediff-access+offset;
if(curtimeout>=timeout) {
return 1;
}
else {
return 0;
}
}
function updateFirstAccess(){
var firstAccessCookieValue=dsgetCookieVal("DSFirstAccess=");
if(firstAccessCookieValue>top.DSfirstAccess){
top.DSfirstAccess=firstAccessCookieValue;
return true;
}
return false;
}
function getTimeoutString(appendSession){
var session_str=dsGetI18Msg("session")+"<br>";
var curdate=new Date();
var curtime=parseInt(""+curdate.getTime()/1000);
var curtimeout=curtime+top.DStimediff-top.DSfirstAccess;
var remainingTime=top.DSmaxTimeout-curtimeout;
var hours=0;
var minutes=0;
var seconds=0;
if(remainingTime>0){
hours= Math.floor(remainingTime/3600);
var rem_seconds=remainingTime%3600;
minutes=Math.floor(rem_seconds/60);
seconds=Math.floor(rem_seconds%60);
if((remainingTime % 30)==0) updateFirstAccess();
}else {
if(updateFirstAccess()){
if(appendSession){
return  session_str+getTimeoutString();
}else {
return  getTimeoutString();
}
}else {
if(appendSession){
return  session_str+"00:00:00";
}else {
return  "00:00:00";
}
}
}
if(hours<=9)
hours="0"+hours;
if(minutes<=9)
minutes="0"+minutes;
if(seconds<=9)
seconds="0"+seconds;
var myclock=hours+":"+minutes+":"+seconds;
if(appendSession){
return session_str+myclock;
}else {
return myclock;
}
}
function showMaxSessionLimit_float(){
var myclock=getTimeoutString(1);
var  dsbversion=parseInt(navigator.appVersion);
if(navigator.appName=="Netscape") {
if(dsbversion<=4) {
document.dsl0.document.liveclock.innerHTML=myclock;
}else {
if(document.getElementById&&(typeof(document.getElementById("dsl0"))!="undefined")){
var elements=document.getElementById("dsl0").getElementsByTagName("span");
elements["liveclock"].innerHTML=myclock;
}
}
}else {
if(document.all&&document.all.dsl0){
document.all.dsl0.document.all.liveclock.innerHTML=myclock;
}
}
}
function showMaxSessionLimit(elementId){
var myclock=dsGetI18Msg("session")+"<br>"
myclock +="&nbsp;"
myclock+=getTimeoutString(0);
myclock +="&nbsp;"
var  dsbversion=parseInt(navigator.appVersion);
if(navigator.appName=="Netscape") {
if(dsbversion<=4) {
eval("document."+elementId+".innerHTML=myclock");
}else {
if(document.getElementById&&(typeof(document.getElementById(elementId))!="undefined")){
document.getElementById(elementId).innerHTML=myclock;
}
}
}else {
if(document.all){
eval("document.all."+elementId+".innerHTML=myclock");
}
}
}
function dsResetStatus()
{
if(typeof(self.status) !="undefined")
self.status="";
}
function dsGetI18Msg(id)
{
var lang="en";
if(typeof(DSLang)=="string") {
lang=DSLang;
lang=lang.replace(/-/g, "_");
}
if(!(lang=="en"||lang=="de"||lang=="fr"||lang=="ja"||lang=="zh"||lang=="zh_cn"||lang=="es"||lang=="ko")) lang="en";
var idle_msg1_en="Your session will expire in";
var idle_msg2_en="minute(s) due to inactivity.";
var idle_msg3_en="Please click [OK] to extend your session.";
var idle_msg4_en="Your session expired due to inactivity."
var max_msg1_en="Your session will expire in less than";
var max_msg2_en="minute(s) due to session length restrictions.";
var max_msg3_en="Your session expired due to session length restrictions.";
var max_msg4_en="Please click [OK] to login again.";
var session_en="Session";
var idle_msg1_de="Ihre Sitzung l\u00E4uft in";
var idle_msg2_de="Minute(n) aufgrund von Inaktivit\u00E4t ab.";
var idle_msg3_de="Klicken Sie auf 'OK', um die Sitzung zu verl\u00E4ngern.";
var idle_msg4_de="Ihre Sitzung ist aufgrund von Inaktivit\u00E4t abgelaufen.";
var max_msg1_de="Ihre Sitzung l\u00E4uft in weniger als";
var max_msg2_de="Minute(n) aufgrund von Beschr\u00E4nkungen der Sitzungsdauer ab.";
var max_msg3_de="Ihre Sitzung ist aufgrund von Beschr\u00E4nkungen der Sitzungsdauer abgelaufen.";
var max_msg4_de="Klicken Sie auf 'OK', um sich wieder anzumelden.";
var session_de="Sitzung";
var idle_msg1_fr="Votre session va expirer dans";
var idle_msg2_fr="minute(s) en raison d\u0027une inactivit\u00E9.";
var idle_msg3_fr="Cliquez sur [OK] pour prolonger votre session.";
var idle_msg4_fr="Votre session a expir\u00E9 en raison d\u0027une inactivit\u00E9.";
var max_msg1_fr="Votre session va expirer dans moins de";
var max_msg2_fr="minute(s) en raison de restrictions de dur\u00E9e de la session.";
var max_msg3_fr="Votre session a expir\u00E9 en raison de restrictions de dur\u00E9e de la session.";
var max_msg4_fr="Cliquez sur [OK] pour vous reconnecter.";
var session_fr="Session";
var idle_msg1_ja="\u4e00\u5b9a\u6642\u9593\u3001\u64cd\u4f5c\u3092\u3057\u306a\u304b\u3063\u305f\u305f\u3081\u3001\u3053\u306e\u30bb\u30c3\u30b7\u30e7\u30f3\u306f\u3001";
var idle_msg2_ja="\u5206\u5F8C\u306B\u671F\u9650\u304C\u5207\u308C\u307E\u3059";
var idle_msg3_ja="\u30bb\u30c3\u30b7\u30e7\u30f3\u3092\u5ef6\u9577\u3059\u308b\u306b\u306f\u3001\u005b\u004f\u004b\u005d\u0020\u3092\u30af\u30ea\u30c3\u30af\u3057\u3066\u304f\u3060\u3055\u3044\u3002";
var idle_msg4_ja="\u4e00\u5b9a\u6642\u9593\u3001\u64cd\u4f5c\u3092\u3057\u306a\u304b\u3063\u305f\u305f\u3081\u3001\u30bb\u30c3\u30b7\u30e7\u30f3\u306e\u671f\u9650\u304c\u5207\u308c\u307e\u3057\u305f\u3002";
var max_msg1_ja="\u30BB\u30C3\u30B7\u30E7\u30F3\u9577\u5236\u9650\u306B\u3088\u308A\u3001\u3053\u306E\u30BB\u30C3\u30B7\u30E7\u30F3\u306F\u3001";
var max_msg2_ja="\u5206\u4ee5\u5185\u306b\u671f\u9650\u304c\u5207\u308c\u307e\u3059\u3002";
var max_msg3_ja="\u30BB\u30C3\u30B7\u30E7\u30F3\u9577\u5236\u9650\u306B\u3088\u308A\u3001\u30BB\u30C3\u30B7\u30E7\u30F3\u306E\u671F\u9650\u304C\u5207\u308C\u307E\u3057\u305F\u3002"
var max_msg4_ja="\u518d\u5ea6\u3001\u30ed\u30b0\u30a4\u30f3\u3059\u308b\u306b\u306f\u3001\u005b\u004f\u004b\u005d\u0020\u3092\u30af\u30ea\u30c3\u30af\u3057\u3066\u304f\u3060\u3055\u3044\u3002";
var session_ja="\u30BB\u30C3\u30B7\u30E7\u30F3";
var idle_msg1_zh_cn="\u8BE5\u4F1A\u8BDD\u5C06\u8FC7\u671F\uFF0C\u8FD8\u6709";
var idle_msg2_zh_cn="\u5206\u949F\uFF0C\u7531\u4E8E\u4F1A\u8BDD\u5904\u4E8E\u975E\u6D3B\u52A8\u72B6\u6001\u3002";
var idle_msg3_zh_cn="\u8BF7\u5355\u51FB\u201C\u786E\u5B9A\u201D\u6765\u5EF6\u957F\u60A8\u7684\u4F1A\u8BDD\u65F6\u95F4\u3002";
var idle_msg4_zh_cn="\u7531\u4E8E\u4F1A\u8BDD\u5904\u4E8E\u975E\u6D3B\u52A8\u72B6\u6001\uFF0C\u8BE5\u4F1A\u8BDD\u5DF2\u8FC7\u671F\u3002";
var max_msg1_zh_cn="\u8BE5\u4F1A\u8BDD\u5C06\u8FC7\u671F\uFF0C\u8FD8\u6709";
var max_msg2_zh_cn="\u5206\u949F\uFF0C\u7531\u4E8E\u4F1A\u8BDD\u7684\u957F\u5EA6\u9650\u5236\u3002";
var max_msg3_zh_cn="\u7531\u4E8E\u4F1A\u8BDD\u7684\u957F\u5EA6\u9650\u5236\uFF0C\u8BE5\u4F1A\u8BDD\u5DF2\u8FC7\u671F\u3002";
var max_msg4_zh_cn="\u8BF7\u5355\u51FB\u201C\u786E\u5B9A\u201D\u91CD\u65B0\u767B\u5F55\u3002";
var session_zh_cn="\u4F1A\u8BDD";
var idle_msg1_zh="\u60A8\u7684\u5DE5\u4F5C\u968E\u6BB5\u5C07\u56E0\u7121\u6CD5\u4F5C\u7528\uFF0C\u800C\u65BC";
var idle_msg2_zh="\u5206\u9418\u5167\u904E\u671F\u3002";
var idle_msg3_zh="\u8ACB\u6309\u4E00\u4E0B\u0020\u005B\u78BA\u5B9A\u005D\u0020\u5EF6\u9577\u60A8\u7684\u5DE5\u4F5C\u968E\u6BB5\u3002";
var idle_msg4_zh="\u60A8\u7684\u5DE5\u4F5C\u968E\u6BB5\u5C07\u56E0\u7121\u6CD5\u4F5C\u7528\u800C\u904E\u671F\u3002";
var max_msg1_zh="\u60A8\u7684\u5DE5\u4F5C\u968E\u6BB5\u5C07\u904E\u671F\uFF0C\u5728";
var max_msg2_zh="\u5206\u9418\u5167\u904E\u671F\u0020\u0028\u56E0\u9577\u5EA6\u9650\u5236\u0029\u3002";
var max_msg3_zh="\u60A8\u7684\u5DE5\u4F5C\u968E\u6BB5\u56E0\u5DE5\u4F5C\u968E\u6BB5\u9577\u5EA6\u9650\u5236\u800C\u904E\u671F\u3002";
var max_msg4_zh="\u8ACB\u6309\u4E00\u4E0B\u0020\u005B\u78BA\u5B9A\u005D\u0020\u518D\u6B21\u767B\u5165\u3002";
var session_zh="\u5DE5\u4F5C\u968E\u6BB5";
var idle_msg1_es="La sesi\u00F3n caducar\u00E1 en";
var idle_msg2_es="minuto(s) por inactividad.";
var idle_msg3_es="Haga clic en [Aceptar] para ampliar la sesi\u00F3n.";
var idle_msg4_es="La sesi\u00F3n ha caducado por inactividad.";
var max_msg1_es="La sesi\u00F3n caducar\u00E1 en menos de";
var max_msg2_es="minuto(s) por restricciones de longitud de sesiones.";
var max_msg3_es="La sesi\u00F3n ha caducado por restricciones de longitud de sesiones.";
var max_msg4_es="Seleccione [Aceptar] para volver a iniciar sesi\u00F3n.";
var session_es="Sesi\u00F3n";
var idle_msg1_ko="\uC138\uC158\uC740";
var idle_msg2_ko="\uBD84\u0020\uB3D9\uC548\u0020\uC0AC\uC6A9\uD558\uC9C0\u0020\uC54A\uC73C\uBA74\u0020\uB9CC\uB8CC\uB429\uB2C8\uB2E4\u002E";
var idle_msg3_ko="\uC138\uC158\uC744\u0020\uC5F0\uC7A5\uD558\uB824\uBA74\u0020\u005B\uD655\uC778\u005D\uC744\u0020\uB204\uB974\uC2ED\uC2DC\uC624\u002E";
var idle_msg4_ko="\uD65C\uB3D9\uC774\u0020\uC5C6\uC5B4\uC11C\u0020\uC138\uC158\uC774\u0020\uB9CC\uB8CC\uB418\uC5C8\uC2B5\uB2C8\uB2E4\u002E";
var max_msg1_ko="\uC138\uC158\u0020\uAE38\uC774\u0020\uC81C\uD55C\uC73C\uB85C\u0020\uC778\uD574\u0020\uC138\uC158\uC774";
var max_msg2_ko="\uBD84\u0020\uD6C4\uC5D0\u0020\uB9CC\uB8CC\uB429\uB2C8\uB2E4\u002E";
var max_msg3_ko="\uC138\uC158\u0020\uAE38\uC774\u0020\uC81C\uD55C\uC73C\uB85C\u0020\uC778\uD574\u0020\uC138\uC158\uC774\u0020\uB9CC\uB8CC\uB418\uC5C8\uC2B5\uB2C8\uB2E4\u002E";
var max_msg4_ko="\u005B\uD655\uC778\u500D\uC744\u0020\uB20C\uB7EC\u0020\uB2E4\uC2DC\u0020\uB85C\uADF8\uC778\uD574\u0020\uC8FC\uC2ED\uC2DC\uC624\u002E";
var session_ko="\uC138\uC158";
var r;
eval("r="+id+"_"+lang);
return r;
}
var dsSessionTimeoutReLoginWindow;
var tAboutToExpireID, tExpiredID, tNoRefrID;
var dsFirstAccess=0;
var g_dsLastAccess=0;
function dsConfirmIdleTimeout(reminder, timeoutRelogin)  
{
var msg;
var statusmsg;
if(reminder) { 
msg=dsGetI18Msg("idle_msg1")+" "+reminder/60+" "+dsGetI18Msg("idle_msg2")+" "+dsGetI18Msg("idle_msg3");
statusmsg=dsGetI18Msg("idle_msg1")+" "+reminder/60+" "+dsGetI18Msg("idle_msg2");
}
else {
msg=dsGetI18Msg("idle_msg4");
if(timeoutRelogin) {
msg+=" "+dsGetI18Msg("max_msg4");
}
statusmsg=dsGetI18Msg("idle_msg4");
}
if(typeof(self.status) !="undefined")
self.status=statusmsg;
parent.setTimeout("dsResetStatus();", 10000);
self.focus();
return (confirm(msg));
} 
function dsConfirmMaxTimeout(reminder, timeoutRelogin)  
{
var msg;
var statusmsg;
if(reminder){ 
msg=dsGetI18Msg("max_msg1")+" "+reminder/60+" "+dsGetI18Msg("max_msg2");
if(timeoutRelogin) {
msg+=" "+dsGetI18Msg("max_msg4");
}
statusmsg=dsGetI18Msg("max_msg1")+" "+reminder/60+" "+dsGetI18Msg("max_msg2");
}
else {
msg=dsGetI18Msg("max_msg3");
if(timeoutRelogin) {
msg+=" "+dsGetI18Msg("max_msg4");
}
statusmsg=dsGetI18Msg("max_msg3");
}
if(typeof(self.status) !="undefined")
self.status=statusmsg;
setTimeout("dsResetStatus();", 10000);
self.focus();
return (confirm(msg));
}
function dsSetTimers(firstAccess, lastAccess, timeout, maxtimeout, reminder, timediff, timeoutRelogin, fromJs, leaveIdleExpiredTimer) 
{
if(top.opener!=null&&top.name=="dsSessionTimeoutReLoginWindow") {
top.opener._dsstw=0;
top.opener.dsFirstAccess=0;
top.opener.g_dsLastAccess=0;
top.opener.dsClearTimers();
top.opener.dsSetTimers(firstAccess, lastAccess, timeout, maxtimeout, reminder, timediff, timeoutRelogin, 1);
top.close();
return;
}
var lastCheck=5;
if(typeof(document)!="object")return;
document.expando=true;
if(typeof(top)!="object") top=window;
if((!top._dsstw||top._dsstw ==0)||(typeof(fromJs)!="undefined")){
top._dsstw=1;
var curdate=new Date();
if(!dsFirstAccess) {
dsFirstAccess=firstAccess;
}
var curtime=parseInt(""+curdate.getTime()/1000)+timediff-dsFirstAccess;
var o=top;
o.dsSessionTimeoutReLoginWindow=null;
o.dsClearTimers(leaveIdleExpiredTimer);
var idleTimeoutReminder=timeout-reminder;
var maxTimeoutReminder=maxtimeout-reminder;
if((typeof(fromJs)=="undefined"||fromJs==1)) {
if(curtime+idleTimeoutReminder<=maxTimeoutReminder) {
if(typeof(leaveIdleExpiredTimer)=="undefined") {
o.tNoRefrID=o.parent.setTimeout("dsGetLastAccess()", (idleTimeoutReminder-lastCheck)*1000);
o.tAboutToExpireID=o.parent.setTimeout("dsSessionAboutToExpire(" +
firstAccess+","+lastAccess+"," +
timeout +","+maxtimeout+","+reminder+","+timediff+","+timeoutRelogin+")", 
idleTimeoutReminder*1000);
}
}else {
var t=maxTimeoutReminder-curtime;
if(t>0) {
if(t-lastCheck>0) o.tNoRefrID=o.parent.setTimeout("dsGetLastAccess()", (t-lastCheck)*1000);
o.tAboutToExpireID=o.parent.setTimeout("dsSessionAboutToExpire(" +
firstAccess+","+lastAccess+"," +
timeout +","+maxtimeout+","+reminder+","+timediff+","+timeoutRelogin+")", 
t*1000);
}
}
}
if(typeof(leaveIdleExpiredTimer)!="undefined") {
return;
}
if(curtime+timeout<maxtimeout) {
o.tNoRefrID=o.parent.setTimeout("dsGetLastAccess()", (timeout-lastCheck)*1000);
o.tExpiredID=o.parent.setTimeout("dsSessionExpired(" +
firstAccess+","+lastAccess+"," +
timeout +","+maxtimeout+","+reminder+","+timediff+","+timeoutRelogin+")", 
timeout*1000);
}else {
var t=maxtimeout-curtime;
if(t>0) {
if(t-lastCheck>0) o.tNoRefrID=o.parent.setTimeout("dsGetLastAccess()", (t-lastCheck)*1000);
o.tExpiredID=o.parent.setTimeout("dsSessionExpired(" +
firstAccess+","+lastAccess+"," +
timeout +","+maxtimeout+","+reminder+","+timediff+","+timeoutRelogin+")", 
t*1000);
}
}
}
}
function dsClearTimers(leaveIdleExpiredTimer)
{
if(typeof(tNoRefrID)!="undefined") tNoRefrID=clearTimeout(tNoRefrID);
if(typeof(tAboutToExpireID)!="undefined") tAboutToExpireID=clearTimeout(tAboutToExpireID);
if(typeof(leaveIdleExpiredTimer)=="undefined") {
if(typeof(tExpiredID)!="undefined") tExpiredID=clearTimeout(tExpiredID);
}
}
function dsCheckMaxSessionTimeout(firstAccess, lastAccess, timeout, maxtimeout, reminder, timediff, timeoutRelogin) 
{
var timedout=0;
var firstAccessCookieValue=dsgetCookieVal("DSFirstAccess=");
updateFirstAccess();
if(top.DSfirstAccess>firstAccess){
firstAccess=top.DSfirstAccess;
}
if(dsCheckTimeout(maxtimeout, firstAccess, timediff) ) {
dsClearTimers();
if(dsConfirmMaxTimeout(0, timeoutRelogin)&&timeoutRelogin==1) {
if(dsSessionTimeoutReLoginWindow==null) {
var url='https://'+getIVEHostname()+"/dana-na/auth/welcome.cgi";
dsSessionTimeoutReLoginWindow=top.open(url, "dsSessionTimeoutReLoginWindow", "toobar=no,location=no,directories=no,status=1,menubar=no,scrollbars=1,resizable=1,width=640,height=480");
}else {
dsSessionTimeoutReLoginWindow.focus();
}
}
timedout=2;
}else if(dsCheckTimeout(maxtimeout-reminder, firstAccess, timediff)) {
if(dsConfirmMaxTimeout(reminder, timeoutRelogin)&&timeoutRelogin==1) {
if(dsSessionTimeoutReLoginWindow==null) {
var url='https://'+getIVEHostname()+"/dana-na/auth/welcome.cgi";
dsSessionTimeoutReLoginWindow=top.open(url, "dsSessionTimeoutReLoginWindow", "toobar=no,location=no,directories=no,status=1,menubar=no,scrollbars=1,resizable=1,width=640,height=480");
}else {
dsSessionTimeoutReLoginWindow.focus();
}
}
timedout=1;
}
return timedout;
}
function dsSessionAboutToExpire(firstAccess, lastAccess, timeout, maxtimeout, reminder, timediff, timeoutRelogin) 
{
if(typeof(lastAccess)!="undefined"&&lastAccess!=null ) { 
var dslastaccess=dsgetCookieVal("DSLastAccess=");
if(dslastaccess>g_dsLastAccess){
g_dsLastAccess=dslastaccess;
} 
if(dslastaccess!=null&&lastAccess<dslastaccess) { 
lastAccess=dslastaccess;
}
var t=dsCheckMaxSessionTimeout(firstAccess, lastAccess, timeout, maxtimeout, reminder, timediff, timeoutRelogin);
if(!t) {
if(dsCheckTimeout(timeout-reminder, lastAccess, timediff)) {
if(dsConfirmIdleTimeout(reminder, timeoutRelogin)){ 
if(!dsCheckMaxSessionTimeout(firstAccess, lastAccess, timeout, maxtimeout, reminder, timediff, timeoutRelogin)) {
var dslastaccess2=dsgetCookieVal("DSLastAccess=");
if(dslastaccess2>g_dsLastAccess){
g_dsLastAccess=dslastaccess2;
} 
if(dslastaccess2==dslastaccess) { 
var img=new Image();
img.src='https://'+getIVEHostname()+"/dana/home/space.gif";
if(typeof(self.status) !="undefined")
self.status="Your session has been extended...";
}
dsSetTimers(firstAccess, dslastaccess2, timeout, maxtimeout, reminder, timediff, timeoutRelogin, 1);
}
}else {
dsSetTimers(firstAccess, lastAccess, timeout, maxtimeout, reminder, timediff, timeoutRelogin, 1, 1);
}
}
}else if(t!=2) {
dsSetTimers(firstAccess, lastAccess, timeout, maxtimeout, reminder, timediff, timeoutRelogin, 1, 1);
}
}
}
function dsSessionExpired(firstAccess, lastAccess, timeout, maxtimeout, reminder, timediff, timeoutRelogin) 
{
var url='https://'+getIVEHostname()+"/dana/home/starter.cgi";
var dslastaccess=dsgetCookieVal("DSLastAccess=");
if(dslastaccess>g_dsLastAccess){
g_dsLastAccess=dslastaccess;
} 
if(dslastaccess!=null&&lastAccess<dslastaccess) { 
lastAccess= dslastaccess;
}
if(dsCheckTimeout(timeout, lastAccess, timediff)) {
dsClearTimers();
if(dsConfirmIdleTimeout(0, timeoutRelogin)&&timeoutRelogin==1){ 
if(dsSessionTimeoutReLoginWindow==null) {
var url='https://'+getIVEHostname()+"/dana-na/auth/welcome.cgi?p=timed-out";
dsSessionTimeoutReLoginWindow=top.open(url, "dsSessionTimeoutReLoginWindow", "toobar=no,location=no,directories=no,status=1,menubar=no,scrollbars=1,resizable=1,width=640,height=480");
}else {
dsSessionTimeoutReLoginWindow.focus();
}
}
return;
}else {
var t=dsCheckMaxSessionTimeout(firstAccess, lastAccess, timeout, maxtimeout, reminder, timediff, timeoutRelogin);
if(!t) {
dsSetTimers(firstAccess, lastAccess, timeout, maxtimeout, reminder, timediff, timeoutRelogin, 1);
}else if(t!=2) dsSetTimers(firstAccess, lastAccess, timeout, maxtimeout, reminder, timediff, timeoutRelogin, 2);
}
}
