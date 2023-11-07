class _UniffiConverterBool extends _UniffiConverterPrimitive {

    @override
    bool read(buf) {
        return lift(buf.read_u8());
    }

    @override
    _UniffiRustBufferBuilder write(bool value, _UniffiRustBufferBuilder buf) {
      if(value) {
        return buf.write_u8(1);
      } else {
        return buf.write_u8(0);
      }
    }

    @override
    bool lift(dynamic value) {
        return value != 0;
    }
    //bool read(_UniffiRustBufferBuilder buf) {
    //    return buf.read_u8() == 1;
    //}

    //_UniffiRustBufferBuilder write(bool value) {
    //    Pointer<_UniffiRustBuffer> _rustBuffer = calloc<_UniffiRustBuffer >();
    //    return _rustBuffer.ref.buffer;
    //    //buf.data.cast<Double> = value;
    //}
}
