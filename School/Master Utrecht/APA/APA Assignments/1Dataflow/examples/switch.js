

function p (i,j, x, y){
  switch (i)
  {
  case 1:
    j(x,y);
	break;
  case 2:
    j(x,x);
	break;
  case 3:
    j(y,x);
	break;
  default:
    j(y,y);
  }
}

main();
function main(){
  var x = -1;
  var y = 2;
  var z = x + y;
  p(z,function(a,b){return a^b;}, x,y);
}