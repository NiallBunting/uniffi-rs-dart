class _UniffiConverterString {
    static check(value) {
        /*if not isinstance(value, str):
            raise TypeError("argument must be str, not {}".format(type(value).__name__))
        return value*/
    }

    static read(buf) {
        /*size = buf.read_i32()
        if size < 0:
            raise InternalError("Unexpected negative string length")
        utf8_bytes = buf.read(size)
        return utf8_bytes.decode("utf-8")*/
    }

    static write(value, buf) {
        /*value = _UniffiConverterString.check(value)
        utf8_bytes = value.encode("utf-8")
        buf.write_i32(len(utf8_bytes))
        buf.write(utf8_bytes)*/
    }

    static String lift(_UniffiRustBuffer buf) {
      return buf.data.toDartString();
    }

    static lower(value) {
        /*value = _UniffiConverterString.check(value)
        with _UniffiRustBuffer.alloc_with_builder() as builder:
            builder.write(value.encode("utf-8"))
            return builder.finalize()*/
    }
}
