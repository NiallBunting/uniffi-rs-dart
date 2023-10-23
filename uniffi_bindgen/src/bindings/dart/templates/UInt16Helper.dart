class _UniffiConverterUInt16 extends _UniffiConverterPrimitiveInt {
    CLASS_NAME = "u16"
    VALUE_MIN = 0
    VALUE_MAX = 2**16

    static read(buf) {
        return buf.read_u16()
    }

    static write_unchecked(value, buf) {
        buf.write_u16(value)
    }
}
