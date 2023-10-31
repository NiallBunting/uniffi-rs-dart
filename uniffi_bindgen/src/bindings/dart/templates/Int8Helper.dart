class _UniffiConverterInt8 extends _UniffiConverterPrimitiveInt {
    static int read(_UniffiRustBufferBuilder buf) {
        return buf.data.cast<Int8>().value;
    }

    static _UniffiRustBufferBuilder write(value) {
        Pointer<_UniffiRustBuffer> _rustBuffer = calloc<_UniffiRustBuffer >();
        return _rustBuffer.ref.buffer;
        //buf.data.cast<Int64> = value;
    }
}
