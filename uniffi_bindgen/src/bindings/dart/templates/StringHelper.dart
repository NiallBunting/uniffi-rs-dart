class _UniffiConverterString {

    late Pointer<_UniffiRustBuffer> _pointer;

    static check(value) {
        /*if not isinstance(value, str):
            raise TypeError("argument must be str, not {}".format(type(value).__name__))
        return value*/
    }

    String lift(_UniffiRustBuffer buf) {
      return buf.data.toDartString();
    }

    _UniffiRustBuffer lower(String value) {

      _pointer = calloc<_UniffiRustBuffer>();
      _pointer.ref
        ..capacity = value.length
        ..len = value.length
        ..data = value.toNativeUtf8();

      return _pointer.ref;
    }



    @override
    void dispose() {
        if (_pointer != null) {
            calloc.free(this._pointer);
        }
    }

    read(_UniffiRustBufferBuilder buf) {
      var size = buf.read_i32();
      if (size < 0) {
          throw "Negative string length";
      }
      return buf.toDartString(size);
      //return utf8_bytes.decode("utf-8")
    }

    _UniffiRustBufferBuilder write(String value, _UniffiRustBufferBuilder buf) {
      return buf;
    }
}
