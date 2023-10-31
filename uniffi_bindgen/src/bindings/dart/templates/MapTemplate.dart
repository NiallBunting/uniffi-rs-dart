{%- let key_ffi_converter = key_type|ffi_converter_name %}
{%- let value_ffi_converter = value_type|ffi_converter_name %}

// Genearted by MapTemplate
class {{ ffi_converter_name }} extends _UniffiConverterRustBuffer {

  static read(_UniffiRustBufferBuilder buf) {
     return buf;
  }

  static _UniffiRustBufferBuilder write(buf) {
     return buf;
  }
}
