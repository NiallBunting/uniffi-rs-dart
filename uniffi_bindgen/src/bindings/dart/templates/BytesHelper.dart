class _UniffiConverterBytes extends _UniffiConverterRustBuffer {
    static read(buf) {
        size = buf.read_i32()
        if size < 0:
            raise InternalError("Unexpected negative byte string length")
        return buf.read(size)
    }

    static write(value, buf) {
        try:
            memoryview(value)
        except TypeError:
            raise TypeError("a bytes-like object is required, not {!r}".format(type(value).__name__))
        buf.write_i32(len(value))
        buf.write(value)
    }
}
