class _UniffiConverterFloat extends _UniffiConverterPrimitiveFloat {
   static double lift(buf) {
      return buf;
   }

    static lower(val) {
      return  val;
    }
}
