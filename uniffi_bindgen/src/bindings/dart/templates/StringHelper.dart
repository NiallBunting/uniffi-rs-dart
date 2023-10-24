class _UniffiConverterString {

    late Pointer<_UniffiRustBuffer> _pointer;

    static check(value) {
        /*if not isinstance(value, str):
            raise TypeError("argument must be str, not {}".format(type(value).__name__))
        return value*/
    }

    static String lift(_UniffiRustBuffer buf) {
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
}
