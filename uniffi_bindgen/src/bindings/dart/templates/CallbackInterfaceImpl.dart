{% if self.include_once_check("CallbackInterfaceRuntime.dart") %}{% include "CallbackInterfaceRuntime.dart" %}{% endif %}

// Declaration and _UniffiConverters for {{ type_name }} Callback Interface

// Defined by CalllbackInterfaceImpl
typedef {{ callback_handler_class }}Typedef = Void Function(Int64 handle, Int32 method, Pointer<Uint8> args_data, Int32 args_len, Pointer<_UniffiRustBuffer> buffer);

void {{ callback_handler_class}}(int handle, int method, Pointer<Uint8> args_data, int args_len, Pointer<_UniffiRustBuffer> buf_ptr) {
  print("calledback {{callback_handler_class}}");
  print("handle {{handle}}");
  print("method {{method}}");
  print("args_data {{args_data}}");
  print("args_len {{args_len}}");
  print("buf_ptr {{buf_ptr}}");
}

final {{ callback_handler_obj }} = NativeCallable<{{ callback_handler_class }}Typedef>.listener({{callback_handler_class}});
bool {{ callback_handler_obj }}Set = false;

/*
# Declaration and _UniffiConverters for {{ type_name }} Callback Interface

def {{ callback_handler_class }}(handle, method, args_data, args_len, buf_ptr):
    {% for meth in methods.iter() -%}
    {% let method_name = format!("invoke_{}", meth.name())|fn_name %}
    def {{ method_name }}(python_callback, args_stream, buf_ptr):
        {#- Unpacking args from the _UniffiRustBuffer #}
        def makeCall():
            {#- Calling the concrete callback object #}
            {%- if meth.arguments().len() != 0 -%}
            return python_callback.{{ meth.name()|fn_name }}(
                {% for arg in meth.arguments() -%}
                {{ arg|read_fn }}(args_stream)
                {%- if !loop.last %}, {% endif %}
                {% endfor -%}
            )
            {%- else %}
            return python_callback.{{ meth.name()|fn_name }}()
            {%- endif %}

        def makeCallAndHandleReturn():
            {%- match meth.return_type() %}
            {%- when Some(return_type) %}
            rval = makeCall()
            with _UniffiRustBuffer.alloc_with_builder() as builder:
                {{ return_type|write_fn }}(rval, builder)
                buf_ptr[0] = builder.finalize()
            {%- when None %}
            makeCall()
            {%- endmatch %}
            return _UNIFFI_CALLBACK_SUCCESS

        {%- match meth.throws_type() %}
        {%- when None %}
        return makeCallAndHandleReturn()
        {%- when Some(err) %}
        try:
            return makeCallAndHandleReturn()
        except {{ err|type_name }} as e:
            # Catch errors declared in the UDL file
            with _UniffiRustBuffer.alloc_with_builder() as builder:
                {{ err|write_fn }}(e, builder)
                buf_ptr[0] = builder.finalize()
            return _UNIFFI_CALLBACK_ERROR
        {%- endmatch %}

    {% endfor %}

    cb = {{ ffi_converter_name }}._handle_map.get(handle)

    if method == IDX_CALLBACK_FREE:
        {{ ffi_converter_name }}._handle_map.remove(handle)

        # Successfull return
        # See docs of ForeignCallback in `uniffi_core/src/ffi/foreigncallbacks.rs`
        return _UNIFFI_CALLBACK_SUCCESS

    {% for meth in methods.iter() -%}
    {% let method_name = format!("invoke_{}", meth.name())|fn_name -%}
    if method == {{ loop.index }}:
        # Call the method and handle any errors
        # See docs of ForeignCallback in `uniffi_core/src/ffi/foreigncallbacks.rs` for details
        try:
            return {{ method_name }}(cb, _UniffiRustBufferStream(args_data, args_len), buf_ptr)
        except BaseException as e:
            # Catch unexpected errors
            try:
                # Try to serialize the exception into a String
                buf_ptr[0] = {{ Type::String.borrow()|lower_fn }}(repr(e))
            except:
                # If that fails, just give up
                pass
            return _UNIFFI_CALLBACK_UNEXPECTED_ERROR
    {% endfor %}

    # This should never happen, because an out of bounds method index won't
    # ever be used. Once we can catch errors, we should return an InternalException.
    # https://github.com/mozilla/uniffi-rs/issues/351

    # An unexpected error happened.
    # See docs of ForeignCallback in `uniffi_core/src/ffi/foreigncallbacks.rs`
    return _UNIFFI_CALLBACK_UNEXPECTED_ERROR

# We need to keep this function reference alive:
# if they get GC'd while in use then UniFFI internals could attempt to call a function
# that is in freed memory.
# That would be...uh...bad. Yeah, that's the word. Bad.
{{ callback_handler_obj }} = _UNIFFI_FOREIGN_CALLBACK_T({{ callback_handler_class }})
_UniffiLib.{{ ffi_init_callback.name() }}({{ callback_handler_obj }})
*/
