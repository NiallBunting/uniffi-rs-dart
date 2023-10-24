class _UniffiConverterUInt64 extends _UniffiConverterPrimitiveInt {
  static int lift(buf) {
     return buf;
  }

  lower(val) {
    return val;
  }
}
