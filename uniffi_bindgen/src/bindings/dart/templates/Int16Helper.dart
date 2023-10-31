class _UniffiConverterInt16 extends _UniffiConverterPrimitiveInt {

    int read(_UniffiRustBufferBuilder buf) {
        return buf.data.cast<Int16>().value;
    }

    _UniffiRustBufferBuilder write(value) {
        //buf.data.cast<Int16> = value;
        Pointer<_UniffiRustBuffer> _rustBuffer = calloc<_UniffiRustBuffer >();
        return _rustBuffer.ref.buffer;
    }
}
