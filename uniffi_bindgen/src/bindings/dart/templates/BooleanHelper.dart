class _UniffiConverterBool extends _UniffiConverterPrimitive {

  static lower(val) {
    return val;
  }

  static bool lift(bool buf) {
     return buf;
  }
}
