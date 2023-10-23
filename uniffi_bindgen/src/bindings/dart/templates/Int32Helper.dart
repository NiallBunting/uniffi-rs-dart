class _UniffiConverterInt32(_UniffiConverterPrimitiveInt) {
    CLASS_NAME = "i32"
    VALUE_MIN = -2**31
    VALUE_MAX = 2**31

    static read(buf) {
        return buf.read_i32()
    }

    static write_unchecked(value, buf) {
        buf.write_i32(value)
    }
}
