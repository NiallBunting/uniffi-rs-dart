//# {{ type_name }}
//# We want to define each variant as a nested class that's also a subclass,
//# which is tricky in Python.  To accomplish this we're going to create each
//# class separately, then manually add the child classes to the base class's
//# __dict__.  All of this happens in dummy class to avoid polluting the module
//# namespace.

// Generated by ErrorTemplate: 1
class {{ type_name }}Exception implements Exception {
  String cause;
  {{ type_name }}Exception(this.cause);
}

//_UniffiTemp{{ type_name }} = {{ type_name }}

// Generated by ErrorTemplate: 2
class {{ type_name }} {  
    final String _errString;

    {{ type_name }}(this._errString);

    {%- for variant in e.variants() -%}
    {%- let variant_type_name = variant.name()|class_name -%}
    {%- if e.is_flat() %}
    {{ type_name }}.{{ variant_type_name }}(this._errString);
    {%- else %}

    // Generated by ErrorTemplate: 2.1
    {{ type_name }}.{{ variant_type_name }}(this._errString);
    //class {{ variant_type_name }} extends _UniffiTemp{{ type_name }} {
    //    {{ variant_type_name }} ({% for field in variant.fields() %}, {{ field.name()|var_name }}{% endfor %}) {
    //        {%- if variant.has_fields() %}
    //        super().__init__(", ".join([
    //            {%- for field in variant.fields() %}
    //            "{{ field.name()|var_name }}={!r}".format({{ field.name()|var_name }}),
    //            {%- endfor %}
    //        ]))
    //        {%- for field in variant.fields() %}
    //        self.{{ field.name()|var_name }} = {{ field.name()|var_name }}
    //        {%- endfor %}
    //        {%- else %}
    //        pass
    //        {%- endif %}
    //    }

    //    __repr__(self) {
    //        return "{{ type_name }}.{{ variant_type_name }}({})".format(str(self))
    //    }
    //}
    {%- endif %}
    //_UniffiTemp{{ type_name }}.{{ variant_type_name }} = {{ variant_type_name }} 
    {%- endfor %}

    @override
    String toString() => _errString;

}

//{{ type_name }} = _UniffiTemp{{ type_name }} 
//del _UniffiTemp{{ type_name }}

// Generated by ErrorTemplate: 3
class {{ ffi_converter_name }} extends _UniffiWithError {
    static _UniffiRustBuffer lift(Pointer<_UniffiRustCallStatus> val) {
      //print(val.ref.error_buf.toDartString());
      return val.ref.error_buf;

    }

    @override
    liftNotStatic(Pointer<_UniffiRustCallStatus> buf) {
      return lift(buf);
    }

    toError(Pointer<_UniffiRustCallStatus> val) {
      {%- for variant in e.variants() %}
      if (val.ref.code == {{ loop.index }}) {
          throw {{ type_name }}.{{ variant.name()|class_name }}(
              {%- if e.is_flat() %}
              {{ Type::String.borrow()|lift_fn }}(val.ref.error_buf),
              {%- else %}
              // TODO, this has multiple fields
              //{%- for field in variant.fields() %}
              //{{ field|lift_fn }}(val)
              //{%- endfor %}
              {{ Type::String.borrow()|lift_fn }}(val.ref.error_buf),
              {%- endif %}
          );
      }
      {%- endfor %}
    }

    static read(buf) {
        //variant = buf.read_i32()
        //{%- for variant in e.variants() %}
        //if variant == {{ loop.index }}:
        //    return {{ type_name }}.{{ variant.name()|class_name }}(
        //        {%- if e.is_flat() %}
        //        {{ Type::String.borrow()|read_fn }}(buf),
        //        {%- else %}
        //        {%- for field in variant.fields() %}
        //        {{ field.name()|var_name }}={{ field|read_fn }}(buf),
        //        {%- endfor %}
        //        {%- endif %}
        //    )
        //{%- endfor %}
        //raise InternalError("Raw enum value doesn't match any cases")
    }

    static write(value, buf) {
        //{%- for variant in e.variants() %}
        //if isinstance(value, {{ type_name }}.{{ variant.name()|class_name }}):
        //    buf.write_i32({{ loop.index }})
        //    {%- for field in variant.fields() %}
        //    {{ field|write_fn }}(value.{{ field.name()|var_name }}, buf)
        //    {%- endfor %}
        //{%- endfor %}
    }
}
