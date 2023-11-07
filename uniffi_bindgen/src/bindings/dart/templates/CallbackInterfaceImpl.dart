{% if self.include_once_check("CallbackInterfaceRuntime.dart") %}{% include "CallbackInterfaceRuntime.dart" %}{% endif %}

// Declaration and _UniffiConverters for {{ type_name }} Callback Interface

// Defined by CalllbackInterfaceImpl

void {{ callback_handler_class}}(int handle, int method, Pointer<Uint8> args_data, int args_len, Pointer<_UniffiRustBuffer> buf_ptr) async {

  {% for meth in methods.iter() -%}
  {% let method_name = format!("invoke_{}", meth.name())|fn_name %}
  int {{ method_name }}(callback, args_stream, buf_ptr) {
        // TODO: The other versions are more complicated, see why
        {% if meth.arguments().len() != 0 -%}
        callback.{{ meth.name()|fn_name }}(
            {% for arg in meth.arguments() -%}
            {{ arg|read_fn }}(args_stream)
            {%- if !loop.last %}, {% endif %}
            {% endfor -%}
        );
        {%- else %}
        callback.{{ meth.name()|fn_name }}();
        {%- endif %}

        return _UNIFFI_CALLBACK.SUCCESS.index;
  }

  {% endfor %}


  //Go through the converter
  //var cb = {{ ffi_converter_name }}().handleMap.get(handle);
  var cb = await ConcurrentHandleMap().get(handle);

  if (method == IDX_CALLBACK_FREE) {
    await ConcurrentHandleMap().remove(handle);
    //{{ ffi_converter_name }}().handleMap.remove(handle);

    //TODO return 0;
  }

  {% for meth in methods.iter() -%}
  {% let method_name = format!("invoke_{}", meth.name())|fn_name -%}
  if (method == {{ loop.index }}) {
    // Call the method and handle any errors
    // See docs of ForeignCallback in `uniffi_core/src/ffi/foreigncallbacks.rs` for details
    try {
        //TODO return below

        {{ method_name }}(cb, _UniffiRustBufferBuilder.fromData(args_data, args_len), buf_ptr);

    // Catch unexpected errors
    } catch (err) {
      try {
          // Try to serialize the exception into a String
          //_UniffiConverterString().write(
          //TODO
          print(err);
          //buf_ptr[0] = {{ Type::String.borrow()|lower_fn }}(repr(e))
       } catch (err) {}
      //TODO return _UNIFFI_CALLBACK_UNEXPECTED_ERROR
    }
  }
  {% endfor %}

  // This should never happen, because an out of bounds method index won't
  // ever be used. Once we can catch errors, we should return an InternalException.
  // https://github.com/mozilla/uniffi-rs/issues/351

  // An unexpected error happened.
  // See docs of ForeignCallback in `uniffi_core/src/ffi/foreigncallbacks.rs`
  //TODO return _UNIFFI_CALLBACK.UNEXPECTED_ERROR.index;
}

final {{ callback_handler_obj }} = NativeCallable<_UniffiCallbackHandlerTypedef>.listener({{callback_handler_class}});

/*
# We need to keep this function reference alive:
# if they get GC'd while in use then UniFFI internals could attempt to call a function
# that is in freed memory.
# That would be...uh...bad. Yeah, that's the word. Bad.
{{ callback_handler_obj }} = _UNIFFI_FOREIGN_CALLBACK_T({{ callback_handler_class }})
_UniffiLib.{{ ffi_init_callback.name() }}({{ callback_handler_obj }})
*/
