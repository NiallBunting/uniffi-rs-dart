
class ConcurrentHandleMap {
    //A map where inserting, getting and removing data is synchronized with a lock.

    static final Map<int, dynamic> _handles = Map<int, dynamic>();
    static int _currentHandle = 0;
    static const int _stride = 1;
    static final Mutex _lock = Mutex();

    ConcurrentHandleMap() {}

    int insert(obj) {
//        await _lock.acquire();
//        try {
            var handle = _currentHandle;
            _currentHandle = _currentHandle + _stride;
            _handles[handle] = obj;
            return handle;
//        } finally {
//          _lock.release();
//        }
    }

    Future<dynamic> get(int handle) async {
        await _lock.acquire();
        try {
          var obj = _handles[handle];
          if(obj == null) {
            throw 'Handle not found';
          }
          return obj;
        } finally {
          _lock.release();
        }
    }

    Future<void> remove(handle) async {
        await _lock.acquire();
        try {
          _handles.remove(handle);
        } finally {
          _lock.release();
        }
    }
}


// Magic number for the Rust proxy to call using the same mechanism as every other method,
// to free the callback once it's dropped by Rust.
const IDX_CALLBACK_FREE = 0;
// Return codes for callback calls

enum _UNIFFI_CALLBACK {
  SUCCESS,
  ERROR,
  UNEXPECTED_ERROR
}


//CallbackInterfaceRuntime
class _UniffiCallbackInterfaceFfiConverter {

  static final ConcurrentHandleMap _cm = ConcurrentHandleMap();

  lift(int handle) {
    return _cm.get(handle);
  }

  int lower(dynamic obj) {
    return _cm.insert(obj);
  }

  static read(_UniffiRustBufferBuilder buf) {
     // u64
     return buf;
  }

  static write(_UniffiRustBufferBuilder buf, value) {
     // u64
     return buf;
  }
}

typedef _UniffiCallbackHandlerTypedef = Void Function(Uint64 handle, Int32 method, Pointer<Uint8> args_data, Int32 args_len, Pointer<_UniffiRustBuffer> buffer);
