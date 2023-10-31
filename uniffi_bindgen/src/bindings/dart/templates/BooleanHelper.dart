class _UniffiConverterBool extends _UniffiConverterPrimitive {


    static read(_UniffiRustBufferBuilder buf) {
        return buf.data.cast<Bool>();
    }

    static _UniffiRustBufferBuilder write(value) {
        Pointer<_UniffiRustBuffer> _rustBuffer = calloc<_UniffiRustBuffer >();
        return _rustBuffer.ref.buffer;
        //buf.data.cast<Double> = value;
    }
}
