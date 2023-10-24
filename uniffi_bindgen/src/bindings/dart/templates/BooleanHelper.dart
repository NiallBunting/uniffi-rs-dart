class _UniffiConverterBool extends _UniffiConverterPrimitive {

  lower(val) {
    return val;
  }

  static bool lift(bool buf) {
     return buf;
  }
}
