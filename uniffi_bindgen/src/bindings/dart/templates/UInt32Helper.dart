class _UniffiConverterUInt32 extends _UniffiConverterPrimitiveInt {


    int read(_UniffiRustBufferBuilder buf) {
        return buf.read_u32();
    }

    _UniffiRustBufferBuilder write(int value) {
        //buf.data.cast<Int16> = value;
        Pointer<_UniffiRustBuffer> _rustBuffer = calloc<_UniffiRustBuffer >();
        return _rustBuffer.ref.buffer;
    }
}
