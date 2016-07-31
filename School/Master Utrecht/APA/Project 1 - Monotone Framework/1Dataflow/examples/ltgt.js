
function lt (x,y) {
  return x<y;
}

var gt = function (x,y) {
  return x>y;
}

var x = 0;
var y = 10;

while(lt(x, 10)){
  
  if(!gt(y, 1)){
    y=y-2;
  }
  else{
    x++; 
	if(x==10){y="done.";}else{y=10;}
  }
}