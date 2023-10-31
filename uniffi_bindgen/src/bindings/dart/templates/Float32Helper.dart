class _UniffiConverterFloat extends _UniffiConverterPrimitiveFloat {
   static double lift(buf) {
      return buf;
   }

    lower(val) {
      return  val;
    }

    @override
    read(_UniffiRustBufferBuilder buf) {
        return buf.data.cast<Float>();
    }

    static _UniffiRustBuffer write(value) {
        Pointer<_UniffiRustBuffer> _rustBuffer = calloc<_UniffiRustBuffer >();
        return _rustBuffer.buffer;
        //buf.data.cast<Double> = value;
    }
}
