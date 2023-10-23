{%- let obj = ci|get_object_definition(name) %}
{%- let (protocol_name, impl_name) = obj|object_names %}
{%- let methods = obj.methods() %}

{% include "Protocol.py" %}

class {{ impl_name }} {
    late Pointer? _pointer;

{%- match obj.primary_constructor() %}
{%-     when Some with (cons) %}
    {{ impl_name }} ({% call py::arg_list_decl(cons) -%}) {
        {%- call py::setup_args_extra_indent(cons) %}
        self._pointer = {% call py::to_ffi_call(cons) %}
{%-     when None %}
    }
{%- endmatch %}

    @override
    void dispose() {
        // In case of partial initialization of instances.
        if (_pointer != null) {
            _rust_call(_UniffiLib.{{ obj.ffi_object_free().name() }}, _pointer)
        }
    }

{%- for cons in obj.alternate_constructors() %}

    @classmethod
    {{ cons.name()|fn_name }}(cls, {% call py::arg_list_decl(cons) %}) {
        {%- call py::setup_args_extra_indent(cons) %}
        # Call the (fallible) function before creating any half-baked object instances.
        pointer = {% call py::to_ffi_call(cons) %}
        return cls._make_instance_(pointer)
     }
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

        return {{ eq.return_type().unwrap()|lift_fn }}({% call py::to_ffi_call_with_prefix("self._pointer", eq) %})
    }

    {{ ne.return_type().unwrap()|type_name }} __ne__(other: object) {
        if not isinstance(other, {{ type_name }}):
            return NotImplemented

        return {{ ne.return_type().unwrap()|lift_fn }}({% call py::to_ffi_call_with_prefix("self._pointer", ne) %})
    }

{%-         when UniffiTrait::Hash { hash } %}
            {%- call py::method_decl("__hash__", hash) %}
{%      endmatch %}
{% endfor %}

{%- if obj.is_trait_interface() %}
{%- let callback_handler_class = format!("UniffiCallbackInterface{}", name) %}
{%- let callback_handler_obj = format!("uniffiCallbackInterface{}", name) %}
{%- let ffi_init_callback = obj.ffi_init_callback() %}
{% include "CallbackInterfaceImpl.py" %}
{%- endif %}
}

class {{ ffi_converter_name }} {
    {%- if obj.is_trait_interface() %}
    _handle_map = ConcurrentHandleMap()
    {%- endif %}

    lift(value: int):
        return {{ impl_name }}._make_instance_(value)

    lower(value: {{ protocol_name }}):
        {%- match obj.imp() %}
        {%- when ObjectImpl::Struct %}
        if not isinstance(value, {{ impl_name }}):
            raise TypeError("Expected {{ impl_name }} instance, {} found".format(type(value).__name__))
        return value._pointer
        {%- when ObjectImpl::Trait %}
        return {{ ffi_converter_name }}._handle_map.insert(value)
        {%- endmatch %}

    read(cls, buf: _UniffiRustBuffer):
        ptr = buf.read_u64()
        if ptr == 0:
            raise InternalError("Raw pointer value was null")
        return cls.lift(ptr)

    write(cls, value: {{ protocol_name }}, buf: _UniffiRustBuffer):
        buf.write_u64(cls.lower(value))
}
