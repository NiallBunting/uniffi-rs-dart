{% if self.include_once_check("CallbackInterfaceRuntime.dart") %}{% include "CallbackInterfaceRuntime.dart" %}{% endif %}

// Declaration and _UniffiConverters for {{ type_name }} Callback Interface

// Defined by CalllbackInterfaceImpl
{{ callback_handler_class }}(handle, method, args_data, args_len, buf_ptr) {
  // TODO : Removed
}
