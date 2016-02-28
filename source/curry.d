module kdtl.curry;
import std.algorithm,
       std.conv,
       std.range,
       std.traits;

template curry(alias func) {
  alias argsintuple = ParameterTypeTuple!func;

  immutable lambdaStr = (lamArgs =>
    (temp) {
      foreach(i, e; argsintuple) {
        temp ~= "(" ~ e.stringof ~ " " ~ lamArgs[i] ~ ") => ";
      }

      return temp ~ "func(" ~ lamArgs.join(", ") ~ ")";
    }("")
  )(argsintuple.length.iota.map!(i => "arg" ~ i.to!string));

  enum curry = mixin(lambdaStr);
}
