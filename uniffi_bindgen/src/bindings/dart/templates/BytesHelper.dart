class _UniffiConverterBytes extends _UniffiConverterRustBuffer {


   //static List<int> lift(buf) {
   //   return buf;
   //}

    lower(val) {
      return  val;
    }

    @override
    read(_UniffiRustBufferBuilder buf) {
     return buf;
  }
}
