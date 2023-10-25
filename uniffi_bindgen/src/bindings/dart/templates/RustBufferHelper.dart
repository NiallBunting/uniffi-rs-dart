// Types conforming to `_UniffiConverterPrimitive` pass themselves directly over the FFI.
class _UniffiConverterPrimitive {
    static check(value) {
        return true;
    }

    static lift(value) {
        return value;
    }

    lower(value) {
        return value;
    }
}

class _UniffiConverterPrimitiveInt extends _UniffiConverterPrimitive {
    //@classmethod
    //def check(cls, value):
    //    try:
    //        value = value.__index__()
    //    except Exception:
    //        raise TypeError("'{}' object cannot be interpreted as an integer".format(type(value).__name__))
    //    if not isinstance(value, int):
    //        raise TypeError("__index__ returned non-int (type {})".format(type(value).__name__))
    //    if not cls.VALUE_MIN <= value < cls.VALUE_MAX:
    //        raise ValueError("{} requires {} <= value < {}".format(cls.CLASS_NAME, cls.VALUE_MIN, cls.VALUE_MAX))
    //    return super().check(value)

    static read(buf) {
        return buf;
    }

    static write_unchecked(value, buf) {
        return value;
    }
}

class _UniffiConverterPrimitiveFloat extends _UniffiConverterPrimitive {
    //@classmethod
    //def check(cls, value):
    //    try:
    //        value = value.__float__()
    //    except Exception:
    //        raise TypeError("must be real number, not {}".format(type(value).__name__))
    //    if not isinstance(value, float):
    //        raise TypeError("__float__ returned non-float (type {})".format(type(value).__name__))
    //    return super().check(value)
    static read(buf) {
        return buf;
    }

    static write_unchecked(value, buf) {
        return value;
    }
}

// Helper class for wrapper types that will always go through a _UniffiRustBuffer.
// Classes should inherit from this and implement the `read` and `write` static methods.
class _UniffiConverterRustBuffer {

    static lift(_UniffiRustBuffer buf) {
        return buf;
    }

    liftNotStatic(_UniffiRustBuffer buf) {
      return lift(buf);
    }

    _UniffiRustBuffer lower(value) {
      return value;
    }
}

class _UniffiWithError {
    static _UniffiRustBuffer lift(Pointer<_UniffiRustCallStatus> val) {
      return val.ref.error_buf;
    }

    @override
    liftNotStatic(Pointer<_UniffiRustCallStatus> buf) {
      return lift(buf);
    }
}
