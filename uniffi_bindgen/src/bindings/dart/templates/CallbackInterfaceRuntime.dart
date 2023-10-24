/*import threading

class ConcurrentHandleMap {
    """
    A map where inserting, getting and removing data is synchronized with a lock.
    """

    ConcurrentHandleMap(self) {
        // type Handle = int
        self._left_map = {}  // type: Dict[Handle, Any]

        self._lock = threading.Lock()
        self._current_handle = 0
        self._stride = 1
    }

    insert(self, obj) {
        with self._lock:
            handle = self._current_handle
            self._current_handle += self._stride
            self._left_map[handle] = obj
            return handle
    }

    get(self, handle) {
        with self._lock:
            obj = self._left_map.get(handle)
        if not obj:
            raise InternalError("No callback in handlemap; this is a uniffi bug")
        return obj
    }

    remove(self, handle) {
        with self._lock:
            if handle in self._left_map:
                obj = self._left_map.pop(handle)
                return obj
    }
}

// Magic number for the Rust proxy to call using the same mechanism as every other method,
// to free the callback once it's dropped by Rust.
IDX_CALLBACK_FREE = 0
// Return codes for callback calls
_UNIFFI_CALLBACK_SUCCESS = 0
_UNIFFI_CALLBACK_ERROR = 1
_UNIFFI_CALLBACK_UNEXPECTED_ERROR = 2
*/

class UniffiCallbackInterfaceFfiConverter {

    static lift(handle) {
    }

    static lower(cb) {
    }
}
