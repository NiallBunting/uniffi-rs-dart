class _UniffiConverterInt64 extends _UniffiConverterPrimitiveInt  {
    CLASS_NAME = "i64"
    VALUE_MIN = -2**63
    VALUE_MAX = 2**63

    static read(buf) {
        return buf.read_i64()
    }

    static write_unchecked(value, buf) {
        buf.write_i64(value)
    }
}
