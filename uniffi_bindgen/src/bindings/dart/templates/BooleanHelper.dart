class _UniffiConverterBool extends _UniffiConverterPrimitive {


    bool read(_UniffiRustBufferBuilder buf) {
        return buf.read_u8() == 1;
    }

    _UniffiRustBufferBuilder write(bool value) {
        Pointer<_UniffiRustBuffer> _rustBuffer = calloc<_UniffiRustBuffer >();
        return _rustBuffer.ref.buffer;
        //buf.data.cast<Double> = value;
    }
}
