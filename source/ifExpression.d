module kdtl.ifExpression;

import std.traits;
// ifExpression for D language
template IF(alias condition){
  //IF!(condition) -> Return : bool
  auto IF(){
    return condition;
  }

  auto IF(T, F)(T trueExpression, F falseExpression){
    //IF!(condition)(T V1 : T V2) -> Return : V1 or V2
    static if(!isFunctionPointer!T && !isFunctionPointer!F)
      return condition ? trueExpression : falseExpression;
    //IF!(condition)(() => T lambdaV1, T V2) -> Return : lambdaV1 or V2
    else static if(isFunctionPointer!T && !isFunctionPointer!F)
      return condition ? trueExpression() : falseExpression;
    //IF!(condition)(T V1, () => T lambdaV2) -> Return : V1 or lambdaV2
    else static if(!isFunctionPointer!T && isFunctionPointer!F)
      return condition ? trueExpression : falseExpression();
    //IF!(condition)(T lambdaV1, () => T lambdaV2) -> Return : lambdaV1 or lambdaV2
    else static if(isFunctionPointer!T && isFunctionPointer!F){
      return condition ? trueExpression() : falseExpression();
    }
  }
}

unittest{
  import std.stdio;

  assert(true == IF!(1 > 0));
  assert(false == IF!(1 < 0));

  assert(1 == IF!(1 > 0)(1, 0));
  assert(0 == IF!(1 < 0)(1, 0));

  assert(1 == IF!(1 > 0)(() => 1, 0));
  assert(0 == IF!(1 < 0)(() => 1, 0));

  assert(1 == IF!(1 > 0)(1, () => 0));
  assert(0 == IF!(1 < 0)(1, () => 0));

  assert("A" == IF!(1 > 0)(() => "A", () => "B"));
  assert("B" == IF!(1 < 0)(() => "A", () => "B"));
}
