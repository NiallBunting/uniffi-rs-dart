class _UniffiConverterInt16 extends _UniffiConverterPrimitiveInt {
    CLASS_NAME = "i16"
    VALUE_MIN = -2**15
    VALUE_MAX = 2**15

    static read(buf) {
        return buf.read_i16()
    }

    static write_unchecked(value, buf) {
        buf.write_i16(value)
    }
}
