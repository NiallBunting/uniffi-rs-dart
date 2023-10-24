class _UniffiConverterFloat extends _UniffiConverterPrimitiveFloat {
   static double lift(buf) {
      return buf;
   }

    lower(val) {
      return  val;
    }
}
