class _UniffiConverterUInt16 extends _UniffiConverterPrimitiveInt {

    static read(_UniffiRustBufferBuilder buf) {
        return buf.data.cast<Uint16>().value;
    }

    static _UniffiRustBufferBuilder write(value) {
        //buf.data.cast<Int16> = value;
        Pointer<_UniffiRustBuffer> _rustBuffer = calloc<_UniffiRustBuffer >();
        return _rustBuffer.ref.buffer;
    }
}
