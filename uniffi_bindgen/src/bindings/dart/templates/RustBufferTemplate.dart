
final class _UniffiRustBuffer extends Struct {
  @Uint32()
  external int capacity;

  @Uint32()
  external int len;

  external Pointer<Utf8> data;

  _UniffiRustBufferBuilder get buffer => _UniffiRustBufferBuilder.fromStrData(data, len);
}

//class _UniffiForeignBytes(ctypes.Structure):
//    _fields_ = [
//        ("len", ctypes.c_int32),
//        ("data", ctypes.POINTER(ctypes.c_char)),
//    ]
//
//    def __str__(self):
//        return "_UniffiForeignBytes(len={}, data={})".format(self.len, self.data[0:self.len])
//
//
//class _UniffiRustBufferStream {
// Pointer<Uint8> pointer;
// int length;
//
// _UniffiRustBufferStream(this.pointer, this.length);
//
//}
//    """
//    Helper for structured reading of bytes from a _UniffiRustBuffer
//    """
//
//    def __init__(self, data, len):
//        self.data = data
//        self.len = len
//        self.offset = 0
//
//    @classmethod
//    def from_rust_buffer(cls, buf):
//        return cls(buf.data, buf.len)
//
//    def remaining(self):
//        return self.len - self.offset
//
//    def _unpack_from(self, size, format):
//        if self.offset + size > self.len:
//            raise InternalError("read past end of rust buffer")
//        value = struct.unpack(format, self.data[self.offset:self.offset+size])[0]
//        self.offset += size
//        return value
//
//    def read(self, size):
//        if self.offset + size > self.len:
//            raise InternalError("read past end of rust buffer")
//        data = self.data[self.offset:self.offset+size]
//        self.offset += size
//        return data
//
//    def read_i8(self):
//        return self._unpack_from(1, ">b")
//
//    def read_u8(self):
//        return self._unpack_from(1, ">B")
//
//    def read_i16(self):
//        return self._unpack_from(2, ">h")
//
//    def read_u16(self):
//        return self._unpack_from(2, ">H")
//
//    def read_i32(self):
//        return self._unpack_from(4, ">i")
//
//    def read_u32(self):
//        return self._unpack_from(4, ">I")
//
//    def read_i64(self):
//        return self._unpack_from(8, ">q")
//
//    def read_u64(self):
//        return self._unpack_from(8, ">Q")
//
//    def read_float(self):
//        v = self._unpack_from(4, ">f")
//        return v
//
//    def read_double(self):
//        return self._unpack_from(8, ">d")
//
//    def read_c_size_t(self):
//        return self._unpack_from(ctypes.sizeof(ctypes.c_size_t) , "@N")
//
class _UniffiRustBufferBuilder {

  late ByteData buffer;
  late int len;
  int offset = 0;

  _UniffiRustBufferBuilder([int len = 16]) {
    this.offset = 0;
    this.buffer = ByteData(len);
    this.len = len;
  }

  _UniffiRustBufferBuilder.fromData(Pointer<Uint8> data, int len) {
    this.offset = 0;
    this.len = len;
    this.buffer = data.asTypedList(len).buffer.asByteData(0);
  }

  _UniffiRustBufferBuilder.fromStrData(Pointer<Utf8> data, int len) {
    this.offset = 0;
    this.len = len;
    this.buffer = data.cast<Uint8>().asTypedList(len).buffer.asByteData(0);
  }

  int get length => offset;

  Pointer<Utf8> toNativeUtf8() {
    final uint8List = buffer.buffer.asUint8List();
    final result = calloc<Uint8>(this.offset);
  
    for (var i = 0; i < this.offset; ++i) {
      result[i] = uint8List[i];
    }
  
    return result.cast<Utf8>();
  }

  String toDartString(int? size) {
    int end = len;
    if (size != null) {
      end = offset + size;
      if (end > len) {
        throw "Longer than string";
      }
    }

    var sublist = Uint8List.sublistView(buffer, offset, end);

    offset = end;
    return String.fromCharCodes(sublist);
  
  }

  _unpack() {

  }

  read_u8() {
    if (this.offset + 1 > this.len) {
      throw "Not enough bytes.";
    }
    var retVal = buffer.getUint8(this.offset);
    this.offset += 1;
    return retVal;
  }

  write_u8(value) {
    if (this.offset + 1 > this.len) {
      throw "Not enough bytes.";
    }
    buffer.setUint8(this.offset, value);
    this.offset += 1;
  }

  read_i32() {
    if (this.offset + 4 > this.len) {
      throw "Not enough bytes.";
    }
    var retVal = buffer.getInt32(this.offset, Endian.big);
    this.offset += 4;
    return retVal;
  }

  write_i32(value) {
    if (this.offset + 4 > this.len) {
      throw "Not enough bytes.";
    }
    buffer.setInt32(this.offset, value, Endian.big);
    this.offset += 4;
  }

  read_u16() {
    if (this.offset + 2 > this.len) {
      throw "Not enough bytes.";
    }
    var retVal = buffer.getUint16(this.offset, Endian.big);
    this.offset += 2;
    return retVal;
  }

  write_u16(value) {
    if (this.offset + 2 > this.len) {
      throw "Not enough bytes.";
    }
    buffer.setUint16(this.offset, value, Endian.big);
    this.offset += 2;
  }

  read_u32() {
    if (this.offset + 4 > this.len) {
      throw "Not enough bytes.";
    }
    var retVal = buffer.getUint32(this.offset, Endian.big);
    this.offset += 4;
    return retVal;
  }

  read_u64() {
    if (this.offset + 8 > this.len) {
      throw "Not enough bytes.";
    }
    var retVal = buffer.getUint64(this.offset, Endian.big);
    this.offset += 8;
    return retVal;
  }

  read_i64() {
    if (this.offset + 8 > this.len) {
      throw "Not enough bytes.";
    }
    var retVal = buffer.getInt64(this.offset, Endian.big);
    this.offset += 8;
    return retVal;
  }

  read_double() {
    if (this.offset + 8 > this.len) {
      throw "Not enough bytes.";
    }
    var retVal = buffer.getFloat64(this.offset, Endian.big);
    this.offset += 8;
    return retVal;
  }
}
//    """
//    Helper for structured writing of bytes into a _UniffiRustBuffer.
//    """
//
//    def __init__(self):
//        self.rbuf = _UniffiRustBuffer.alloc(16)
//        self.rbuf.len = 0
//
//    def finalize(self):
//        rbuf = self.rbuf
//        self.rbuf = None
//        return rbuf
//
//    def discard(self):
//        if self.rbuf is not None:
//            rbuf = self.finalize()
//            rbuf.free()
//
//    @contextlib.contextmanager
//    def _reserve(self, num_bytes):
//        if self.rbuf.len + num_bytes > self.rbuf.capacity:
//            self.rbuf = _UniffiRustBuffer.reserve(self.rbuf, num_bytes)
//        yield None
//        self.rbuf.len += num_bytes
//
//    def _pack_into(self, size, format, value):
//        with self._reserve(size):
//            # XXX TODO: I feel like I should be able to use `struct.pack_into` here but can't figure it out.
//            for i, byte in enumerate(struct.pack(format, value)):
//                self.rbuf.data[self.rbuf.len + i] = byte
//
//    def write(self, value):
//        with self._reserve(len(value)):
//            for i, byte in enumerate(value):
//                self.rbuf.data[self.rbuf.len + i] = byte
//
//    def write_i8(self, v):
//        self._pack_into(1, ">b", v)
//
//    def write_u8(self, v):
//        self._pack_into(1, ">B", v)
//
//    def write_i16(self, v):
//        self._pack_into(2, ">h", v)
//
//    def write_u16(self, v):
//        self._pack_into(2, ">H", v)
//
//    def write_i32(self, v):
//        self._pack_into(4, ">i", v)
//
//    def write_u32(self, v):
//        self._pack_into(4, ">I", v)
//
//    def write_i64(self, v):
//        self._pack_into(8, ">q", v)
//
//    def write_u64(self, v):
//        self._pack_into(8, ">Q", v)
//
//    def write_float(self, v):
//        self._pack_into(4, ">f", v)
//
//    def write_double(self, v):
//        self._pack_into(8, ">d", v)
//
//    def write_c_size_t(self, v):
//        self._pack_into(ctypes.sizeof(ctypes.c_size_t) , "@N", v)
