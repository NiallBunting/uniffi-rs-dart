class _UniffiConverterBytes extends _UniffiConverterRustBuffer {


   static List<int> lift(buf) {
      return buf;
   }

    lower(val) {
      return  val;
    }
}
