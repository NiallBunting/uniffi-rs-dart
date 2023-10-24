class _UniffiConverterInt64 extends _UniffiConverterPrimitiveInt  {
   static int lift(buf) {
      return buf;
   }

  static lower(val) {
    return val;
  }
}
