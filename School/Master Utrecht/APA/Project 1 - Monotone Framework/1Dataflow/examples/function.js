function fib(n){
  switch(n){
  case 0: return 1;
  case 1: return 1;
  default: return fib(n-2) + fib(n-1);
  }
}

var n;
n = true;
fib(n);

function evilcase(n){
  switch(n){
  case 0: 
  case 1: n+1;
  case 2: break;
  case 3: n+2;
  default: break;  
  }
  return n+3;
  return;
}

var f = (function(k){
  function f(n){
    return fib(n);
  }
  return f(k);
});

f(false);
