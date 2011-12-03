$("ul").find("ul").hide();
$("ul > li.active").find("ul").show().end().parents().show();
alert('testing');