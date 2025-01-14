{%- let inner_ffi_converter = inner_type|ffi_converter_name %}

// Generated by OptionalTemplate
class {{ ffi_converter_name }} extends _UniffiConverterRustBuffer<{{type_name}}> {

  write(_UniffiRustBufferBuilder buf, value) {
    if(value == null) {
      buf.write_u8(0);
      return buf;
    }
    buf.write_u8(1);
    //{{ inner_ffi_converter }}.write(value, buf)
  }

  read(_UniffiRustBufferBuilder buf) {
    var flag = buf.read_u8();
    if(flag == 0) {
      return null;
    } else if (flag == 1) {
      return {{ inner_ffi_converter }}().read(buf);
    } else {
      throw "Unexpected flag byte for optional type";
    }
  }


  //// U8 - is the storage
  //@override
  //{{ type_name }} lift(_UniffiRustBuffer buf) {
  //  if (buf.len > 0) {
  //    buf.data = Pointer.fromAddress(buf.data.address + 0x5);
  //    return {{ inner_ffi_converter }}().lift(buf);
  //  } else {
  //    return null;
  //  }
  //}

  //@override
  //_UniffiRustBuffer lower(buf) {
  //  if (buf == null) {
  //    return {{ inner_ffi_converter }}.write("\u{0}");
  //  } else {
  //    return {{ inner_ffi_converter }}.write("\u{1}" + buf);
  //  }
  //}
}
