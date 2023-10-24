class _UniffiConverterBool extends _UniffiConverterPrimitive {
  static lift(val) {
    return val;
  }

  static lower(val) {
    return val;
  }

    static read(buf) {
        return buf;
    }
}
