class _UniffiConverterBytes extends _UniffiConverterRustBuffer {


   static List<int> lift(buf) {
      return buf;
   }

    static lower(val) {
      return  val;
    }
}
