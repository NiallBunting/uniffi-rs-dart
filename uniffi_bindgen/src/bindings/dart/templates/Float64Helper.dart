class _UniffiConverterDouble extends _UniffiConverterPrimitiveFloat {
    static read(buf):
        return buf.read_double()

    static write_unchecked(value, buf):
        buf.write_double(value)
}
