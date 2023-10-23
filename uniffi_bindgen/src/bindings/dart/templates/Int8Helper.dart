class _UniffiConverterInt8(_UniffiConverterPrimitiveInt) {
    CLASS_NAME = "i8"
    VALUE_MIN = -2**7
    VALUE_MAX = 2**7

    static read(buf) {
        return buf.read_i8()
    }

    static write_unchecked(value, buf) {
        buf.write_i8(value)
    }
}
