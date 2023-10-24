class _UniffiConverterString {
    static check(value) {
        /*if not isinstance(value, str):
            raise TypeError("argument must be str, not {}".format(type(value).__name__))
        return value*/
    }

    static String lift(_UniffiRustBuffer buf) {
      return buf.data.toDartString();
    }

    static _UniffiRustBuffer lower(String value) {
      print("TODO: Need to free string this");
      return _UniffiRustBuffer.allocate(value.length, value.length, value.toNativeUtf8());
    }
}
