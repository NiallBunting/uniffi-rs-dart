class _UniffiConverterInt32 extends _UniffiConverterPrimitiveInt {
    int read(_UniffiRustBufferBuilder buf) {
        return buf.read_i32();
    }

    _UniffiRustBufferBuilder write(int value) {
        //buf.data.cast<Int32> = value;
      Pointer<_UniffiRustBuffer> pointer = calloc<_UniffiRustBuffer>();
      pointer.ref
        ..capacity = 4
        ..len = 4
        ..data = "0000".toNativeUtf8();

        return pointer.ref.buffer;
    }
}
