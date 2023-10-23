class _UniffiConverterFloat extends _UniffiConverterPrimitiveFloat {
    static read(buf) {
        return buf.read_float()
    }

    static write_unchecked(value, buf) {
        buf.write_float(value)
    }
}
