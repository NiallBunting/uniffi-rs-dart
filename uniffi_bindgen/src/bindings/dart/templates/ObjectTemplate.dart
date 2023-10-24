{%- let obj = ci|get_object_definition(name) %}
{%- let (protocol_name, impl_name) = obj|object_names %}
{%- let methods = obj.methods() %}

{% include "Protocol.dart" %}

// Generated By: ObjectTemplate:1
class {{ impl_name }} {
    late Pointer _pointer;

{%- match obj.primary_constructor() %}
{%-     when Some with (cons) %}
    {{ impl_name }} ({% call py::arg_list_decl(cons) -%}) {
        {%- call py::setup_args(cons) %}
        {%- call py::create_rust_callback() %}
        _pointer = {% call py::to_ffi_call(cons, "_rustCallStatus") %};
    }
{%-     when None %}
{%- endmatch %}

    @override
    void dispose() {
        // In case of partial initialization of instances.
        if (_pointer != null) {
            {%- call py::create_rust_callback() %}
            _rustCall(() => _UniffiLib_{{ obj.ffi_object_free().name() }}_func(_pointer, _rustCallStatus), _rustCallStatus);
        }
    }

{%- for cons in obj.alternate_constructors() %}

    /*static {{ cons.name()|fn_name }}({% call py::arg_list_decl(cons) %}) {
    //    {%- call py::setup_args(cons) %}
    //    // Call the (fallible) function before creating any half-baked object instances.
    //    this._pointer = {% call py::to_ffi_call(cons, "notimpl") %};
    //    return make_instance_(_pointer):// TODO
    //}*/
{% endfor %}

{%- for meth in obj.methods() -%}
    {%- call py::method_decl(meth.name()|fn_name, meth) %}
{% endfor %}

{%- for tm in obj.uniffi_traits() -%}
{%-     match tm %}
{%-         when UniffiTrait::Debug { fmt } %}
            {%- call py::method_decl("__repr__", fmt) %}
{%-         when UniffiTrait::Display { fmt } %}
            {%- call py::method_decl("__str__", fmt) %}
{%-         when UniffiTrait::Eq { eq, ne } %}
    {{ eq.return_type().unwrap()|type_name }} __eq__(other: object) {
        if not isinstance(other, {{ type_name }}):
            return NotImplemented

        {%- call py::create_rust_callback() %}
        return {{ eq.return_type().unwrap()|lift_fn }}({% call py::to_ffi_call_with_prefix("_pointer", eq, "_rustCallStatus") %})
    }

    {{ ne.return_type().unwrap()|type_name }} __ne__(other: object) {
        if not isinstance(other, {{ type_name }}):
            return NotImplemented

        {%- call py::create_rust_callback() %}
        return {{ ne.return_type().unwrap()|lift_fn }}({% call py::to_ffi_call_with_prefix("_pointer", ne, "_rustCallStatus") %})
    }

{%-         when UniffiTrait::Hash { hash } %}
            {%- call py::method_decl("__hash__", hash) %}
{%      endmatch %}
{% endfor %}

{%- if obj.is_trait_interface() %}
{%- let callback_handler_class = format!("UniffiCallbackInterface{}", name) %}
{%- let callback_handler_obj = format!("uniffiCallbackInterface{}", name) %}
{%- let ffi_init_callback = obj.ffi_init_callback() %}
{% include "CallbackInterfaceImpl.dart" %}
{%- endif %}
}

// Generated By: ObjectTemplate:2
class {{ ffi_converter_name }} {
    {%- if obj.is_trait_interface() %}
    _handle_map = ConcurrentHandleMap()
    {%- endif %}

    /*static {{ impl_name }} lift({{ protocol_name }} value) {
      // TODO: Do something with value?
      return {{ impl_name }}();
    }*/

    static lift(value) {

    }

    static lower(value) {

    }

    /*
    static {{ protocol_name }} lower({{ impl_name }} value) {
        {%- match obj.imp() %}
        {%- when ObjectImpl::Struct %}
        //if not isinstance(value, {{ impl_name }}):
        //    raise TypeError("Expected {{ impl_name }} instance, {} found".format(type(value).__name__))
        //return value._pointer
        {%- when ObjectImpl::Trait %}
        //return {{ ffi_converter_name }}._handle_map.insert(value)
        {%- endmatch %}
        return {{ protocol_name }}();
    }*/

    static read(_UniffiRustBuffer buf) {
        //ptr = buf.read_u64()
        //if ptr == 0:
        //    raise InternalError("Raw pointer value was null")
        //return lift(ptr)
    }

    static write({{ protocol_name }} value, _UniffiRustBuffer buf) {
        //buf.write_u64(cls.lower(value))
    }
}
