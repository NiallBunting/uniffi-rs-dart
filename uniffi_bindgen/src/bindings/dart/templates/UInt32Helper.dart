class _UniffiConverterUInt32(_UniffiConverterPrimitiveInt) {
    CLASS_NAME = "u32"
    VALUE_MIN = 0
    VALUE_MAX = 2**32

    static read(buf) {
        return buf.read_u32()
    }

    static write_unchecked(value, buf) {
        buf.write_u32(value)
    }

}
