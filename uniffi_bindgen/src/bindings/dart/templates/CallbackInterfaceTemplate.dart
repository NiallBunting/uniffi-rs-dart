{%- let cbi = ci|get_callback_interface_definition(name) %}
{%- let callback_handler_class = format!("UniffiCallbackInterface{}", name) %}
{%- let callback_handler_obj = format!("uniffiCallbackInterface{}", name) %}
{%- let ffi_init_callback = cbi.ffi_init_callback() %}
{%- let protocol_name = type_name.clone() %}
{%- let methods = cbi.methods() %}

{% include "Protocol.dart" %}
{% include "CallbackInterfaceImpl.dart" %}

// The _UniffiConverter which transforms the Callbacks in to Handles to pass to Rust.
//late {{ ffi_converter_name }} = UniffiCallbackInterfaceFfiConverter();
