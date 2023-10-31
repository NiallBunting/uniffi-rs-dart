class _UniffiConverterDouble extends _UniffiConverterPrimitiveFloat {

    read(_UniffiRustBufferBuilder buf) {
        return buf.read_double();
    }

    _UniffiRustBufferBuilder write(value) {
        Pointer<_UniffiRustBuffer> _rustBuffer = calloc<_UniffiRustBuffer >();
        return _rustBuffer.ref.buffer;
        //buf.data.cast<Double> = value;
    }
}
