module kdtl.anonymousClass;
import std.algorithm,
       std.typetuple,
       std.typecons,
       std.string,
       std.array,
       std.range,
       std.conv;

private class EmptyArgument {}

private template AnonymousClassImpl(
    string BaseClassName,
    string bodyString,
    alias arguments = tuple()
  ) {
  enum AnonymousClassImpl = () {
    
    string generateString(
          string parameters      = null,
          string argumentLabels  = null,
          string argumentValues  = null
        ) {
      if (
          parameters     !is null
       && argumentLabels !is null
       && argumentValues !is null) {
        return 
          "() {"
        ~   "class AnonymousClassMain : " ~ BaseClassName ~ "{"
        ~     "this(" ~ parameters ~ ") {"
        ~       "super(" ~ argumentLabels ~ ");"
        ~     "}"
        ~     bodyString
        ~   "}"
        ~   "return new AnonymousClassMain(" ~ argumentValues ~ ");"
        ~ "}()";
      } else {
        return 
          "() {"
        ~   "class AnonymousClassMain : " ~ BaseClassName ~ "{"
        ~     "this() {"
        ~       "super();"
        ~     "}"
        ~     bodyString
        ~   "}"
        ~   "return new AnonymousClassMain();"
        ~ "}()";
      }
    }
    
    static if (arguments.length == 0) {
      return generateString;
    } else {
      immutable types = (temp) {
        int i;
        foreach (argument; arguments.Types) {
          temp ~= (i ? "," : "") ~ argument.stringof;
          i++;
        }
        return temp;
      }("").split(",");
      immutable argumentLabels = arguments.length.iota.map!(i => " arg" ~ i.to!string).array;
      immutable argumentValues = arguments.stringof.replace("Tuple", "");
      immutable parameters =
        (temp =>
          (Args) {
            int i;
            foreach (argument; arguments) {
              temp ~= (i ? "," : "") ~ types[i].to!string ~ Args[i];
              ++i;
            }
            return temp;
          }(argumentLabels)
        )("");

      return generateString(
            parameters,
            argumentLabels.join(","),
            argumentValues
          );
    }
  }();
}

auto AnonymousClass(
      string BaseClassName,
      string bodyString,
      alias arguments = tuple()
    )() {
  static if (arguments.length == 0) {
    return mixin(AnonymousClassImpl!(BaseClassName, bodyString));
  } else {
    return mixin(AnonymousClassImpl!(BaseClassName, bodyString, arguments));
  }
}
