class _UniffiConverterInt64 extends _UniffiConverterPrimitiveInt  {

    int read(_UniffiRustBufferBuilder buf) {
        return buf.read_i32();
    }

    _UniffiRustBufferBuilder write(int value) {
      Pointer<_UniffiRustBuffer> pointer = calloc<_UniffiRustBuffer>();
      pointer.ref
        ..capacity = 8
        ..len = 8
        ..data = "0000".toNativeUtf8();

        return pointer.ref.buffer;
    }
}
