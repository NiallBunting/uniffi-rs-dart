// A handful of classes and functions to support the generated data structures.
// This would be a good candidate for isolating in its own ffi-support lib.

final class _UniffiRustCallStatus extends Struct {
  @Uint8()
  external int code;

  external _UniffiRustBuffer error_buf;
}



enum RUST_CALL_STATUS { CALL_SUCCESS, CALL_ERROR, CALL_PANIC }


// This is just a wrapper
_rustCall(fn, rustCallStatus) {
  return _rustCallWithError(null, fn, rustCallStatus);
}

// This is just a wrapper
_rustCallWithError(_UniffiWithError? error, fn, Pointer<_UniffiRustCallStatus> rustCallStatus) {
  var fnResult = fn();

  _rustCallCheckStatus(error, rustCallStatus);

  calloc.free(rustCallStatus);
  return fnResult;
}

void _rustCallCheckStatus(_UniffiWithError? error, Pointer<_UniffiRustCallStatus> rustCallStatus) {
  if (rustCallStatus.ref.code == RUST_CALL_STATUS.CALL_SUCCESS.index) {
    return;
  } else if (rustCallStatus.ref.code == RUST_CALL_STATUS.CALL_ERROR.index) {
    if(error == null) {
      throw 'CALL_ERROR but error converter is null.';
    } else {
      throw error.toError(rustCallStatus);
    }
  } else if (rustCallStatus.ref.code == RUST_CALL_STATUS.CALL_PANIC.index) {
    throw 'Panic: Rust Panic: ${rustCallStatus.ref.error_buf.data.toDartString()}';
  } else {
    throw 'PANIC: rustCallStatus.ref.code undefined value: ${rustCallStatus.ref.code}';
  }
}

//class InternalError(Exception):
//    pass
//
//class _UniffiRustCallStatus(ctypes.Structure):
//    """
//    Error runtime.
//    """
//    _fields_ = [
//        ("code", ctypes.c_int8),
//        ("error_buf", _UniffiRustBuffer),
//    ]
//
//    # These match the values from the uniffi::rustcalls module
//    CALL_SUCCESS = 0
//    CALL_ERROR = 1
//    CALL_PANIC = 2
//
//    def __str__(self):
//        if self.code == _UniffiRustCallStatus.CALL_SUCCESS:
//            return "_UniffiRustCallStatus(CALL_SUCCESS)"
//        elif self.code == _UniffiRustCallStatus.CALL_ERROR:
//            return "_UniffiRustCallStatus(CALL_ERROR)"
//        elif self.code == _UniffiRustCallStatus.CALL_PANIC:
//            return "_UniffiRustCallStatus(CALL_PANIC)"
//        else:
//            return "_UniffiRustCallStatus(<invalid code>)"
//
//def _rust_call(fn, *args):
//    # Call a rust function
//    return _rust_call_with_error(None, fn, *args)
//
//def _rust_call_with_error(error_ffi_converter, fn, *args):
//    # Call a rust function and handle any errors
//    #
//    # This function is used for rust calls that return Result<> and therefore can set the CALL_ERROR status code.
//    # error_ffi_converter must be set to the _UniffiConverter for the error class that corresponds to the result.
//    call_status = _UniffiRustCallStatus(code=_UniffiRustCallStatus.CALL_SUCCESS, error_buf=_UniffiRustBuffer(0, 0, None))
//
//    args_with_error = args + (ctypes.byref(call_status),)
//    result = fn(*args_with_error)
//    _uniffi_check_call_status(error_ffi_converter, call_status)
//    return result
//
//def _uniffi_check_call_status(error_ffi_converter, call_status):
//    if call_status.code == _UniffiRustCallStatus.CALL_SUCCESS:
//        pass
//    elif call_status.code == _UniffiRustCallStatus.CALL_ERROR:
//        if error_ffi_converter is None:
//            call_status.error_buf.free()
//            raise InternalError("_rust_call_with_error: CALL_ERROR, but error_ffi_converter is None")
//        else:
//            raise error_ffi_converter.lift(call_status.error_buf)
//    elif call_status.code == _UniffiRustCallStatus.CALL_PANIC:
//        # When the rust code sees a panic, it tries to construct a _UniffiRustBuffer
//        # with the message.  But if that code panics, then it just sends back
//        # an empty buffer.
//        if call_status.error_buf.len > 0:
//            msg = _UniffiConverterString.lift(call_status.error_buf)
//        else:
//            msg = "Unknown rust panic"
//        raise InternalError(msg)
//    else:
//        raise InternalError("Invalid _UniffiRustCallStatus code: {}".format(
//            call_status.code))
//
//# A function pointer for a callback as defined by UniFFI.
//# Rust definition `fn(handle: u64, method: u32, args: _UniffiRustBuffer, buf_ptr: *mut _UniffiRustBuffer) -> int`
//_UNIFFI_FOREIGN_CALLBACK_T = ctypes.CFUNCTYPE(ctypes.c_int, ctypes.c_ulonglong, ctypes.c_ulong, ctypes.POINTER(ctypes.c_char), ctypes.c_int, ctypes.POINTER(_UniffiRustBuffer))
//
//# UniFFI future continuation
//_UNIFFI_FUTURE_CONTINUATION_T = ctypes.CFUNCTYPE(None, ctypes.c_size_t, ctypes.c_int8)
//
