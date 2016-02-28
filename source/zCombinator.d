module kdtl.zCombinator;

R delegate(Args) Z(R, Args...)(R delegate(R delegate(Args), Args) f){
  return (Args args) => f(Z(f), args);
}

unittest {
  assert(Z((ulong delegate(ulong) f, ulong n) =>
        n == 1 ? 1 : n * f(n - 1)
      )(5) == 120);
}
