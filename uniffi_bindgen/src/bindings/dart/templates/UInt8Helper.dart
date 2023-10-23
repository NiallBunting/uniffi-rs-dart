class _UniffiConverterUInt8(_UniffiConverterPrimitiveInt) {
    CLASS_NAME = "u8"
    VALUE_MIN = 0
    VALUE_MAX = 2**8

    static read(buf) {
        return buf.read_u8()
    }

    static write_unchecked(value, buf) {
        buf.write_u8(value)
    }
}
