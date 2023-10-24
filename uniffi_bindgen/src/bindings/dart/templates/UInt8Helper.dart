class _UniffiConverterUInt8 extends _UniffiConverterPrimitiveInt {
  static int lift(buf) {
     return buf;
  }

  lower(val) {
    return val;
  }

}
