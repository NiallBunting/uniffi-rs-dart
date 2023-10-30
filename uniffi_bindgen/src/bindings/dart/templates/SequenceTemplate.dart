{%- let inner_ffi_converter = inner_type|ffi_converter_name %}
{%- let inner_type_name = inner_type|type_name %}

// Generated by SequenceTemplate
class {{ ffi_converter_name}} extends _UniffiConverterRustBuffer {

    // Return List
    static lift(_UniffiRustBuffer buf) {
        var count = buf.data.cast<Int32>();
        print(count.value);
        print("TODO");
        List<{{ inner_type_name }}> list = [];
        return list;
    }

    // Take lift
    _UniffiRustBuffer lower(value) {
      return value;
    }
}
