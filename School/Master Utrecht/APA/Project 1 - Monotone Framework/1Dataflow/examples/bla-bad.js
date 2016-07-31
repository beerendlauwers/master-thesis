var x = 6;

var f = function (y){
  return y;
}

var z = f(x);

z = 'test';

// We should be able to infer that f refers to an anonymous function and that z has the type of x (number).
