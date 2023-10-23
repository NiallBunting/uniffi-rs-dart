class _UniffiConverterBool extends _UniffiConverterPrimitive {

    static check(cls, value) {
        return not not value
    }

    static read(cls, buf) {
        return cls.lift(buf.read_u8())
    }

    static write_unchecked(cls, value, buf) {
        buf.write_u8(value)
    }

    static lift(value) {
        return value != 0
    }
}
