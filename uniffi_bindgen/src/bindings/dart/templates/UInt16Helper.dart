class _UniffiConverterUInt16 extends _UniffiConverterPrimitiveInt {

    int read(_UniffiRustBufferBuilder buf) {
        return buf.read_u16();
    }

    _UniffiRustBufferBuilder write(int value, _UniffiRustBufferBuilder buf) {
        return buf.write_u16(value);
    }
}
