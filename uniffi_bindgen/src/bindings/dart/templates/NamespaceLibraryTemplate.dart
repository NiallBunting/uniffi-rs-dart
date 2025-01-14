//# Define some ctypes FFI types that we use in the library
//
//"""
//ctypes type for the foreign executor callback.  This is a built-in interface for scheduling
//tasks
//
//Args:
//  executor: opaque c_size_t value representing the eventloop
//  delay: delay in ms
//  task: function pointer to the task callback
//  task_data: void pointer to the task callback data
//
//Normally we should call task(task_data) after the detail.
//However, when task is NULL this indicates that Rust has dropped the ForeignExecutor and we should
//decrease the EventLoop refcount.
//"""
//_UNIFFI_FOREIGN_EXECUTOR_CALLBACK_T = ctypes.CFUNCTYPE(ctypes.c_int8, ctypes.c_size_t, ctypes.c_uint32, ctypes.c_void_p, ctypes.c_void_p)
//
//"""
//Function pointer for a Rust task, which a callback function that takes a opaque pointer
//"""
//_UNIFFI_RUST_TASK = ctypes.CFUNCTYPE(None, ctypes.c_void_p, ctypes.c_int8)
//
//def _uniffi_future_callback_t(return_type):
//    """
//    Factory function to create callback function types for async functions
//    """
//    return ctypes.CFUNCTYPE(None, ctypes.c_size_t, return_type, _UniffiRustCallStatus)
//
//def _uniffi_load_indirect():
//    """
//    This is how we find and load the dynamic library provided by the component.
//    For now we just look it up by name.
//    """
//    if sys.platform == "darwin":
//        libname = "lib{}.dylib"
//    elif sys.platform.startswith("win"):
//        # As of python3.8, ctypes does not seem to search $PATH when loading DLLs.
//        # We could use `os.add_dll_directory` to configure the search path, but
//        # it doesn't feel right to mess with application-wide settings. Let's
//        # assume that the `.dll` is next to the `.py` file and load by full path.
//        libname = os.path.join(
//            os.path.dirname(__file__),
//            "{}.dll",
//        )
//    else:
//        # Anything else must be an ELF platform - Linux, *BSD, Solaris/illumos
//        libname = "lib{}.so"
//
//    libname = libname.format("{{ config.cdylib_name() }}")
//    path = os.path.join(os.path.dirname(__file__), libname)
//    lib = ctypes.cdll.LoadLibrary(path)
//    return lib

DynamicLibrary _uniffiLoadDynamicLibrary() {

  final path = Platform.isWindows ? "lib{{ config.cdylib_name() }}.dll" : "lib{{ config.cdylib_name() }}.so";
  var lib = Platform.isIOS
      ? DynamicLibrary.process()
      : Platform.isMacOS
          ? DynamicLibrary.executable()
          : DynamicLibrary.open(path);

  _uniffi_check_contract_api_version(lib);

  return lib;
}

final _uniffiLib = _uniffiLoadDynamicLibrary();
//
_uniffi_check_contract_api_version(DynamicLibrary lib) {

  _UniffiLib_{{ ci.ffi_uniffi_contract_version().name() }}_d contractFunc = lib.lookup<NativeFunction<_UniffiLib_{{ ci.ffi_uniffi_contract_version().name() }}_c>>('{{ ci.ffi_uniffi_contract_version().name() }}').asFunction();

  // Get the bindings contract version from our ComponentInterface
  var bindings_contract_version = {{ ci.uniffi_contract_version() }};
  // Get the scaffolding contract version by calling the into the dylib
  var scaffolding_contract_version = contractFunc();

  if (bindings_contract_version != scaffolding_contract_version) {
    throw "UniFFI contract version mismatch: try cleaning and rebuilding your project";
  }
}
//
//def _uniffi_check_api_checksums(lib):
//    {%- for (name, expected_checksum) in ci.iter_checksums() %}
//    if lib.{{ name }}() != {{ expected_checksum }}:
//        raise InternalError("UniFFI API checksum mismatch: try cleaning and rebuilding your project")
//    {%- else %}
//    pass
//    {%- endfor %}
//
//# A ctypes library to expose the extern-C FFI definitions.
//# This is an implementation detail which will be called internally by the public API.
//
{%- for func in ci.iter_ffi_function_definitions() %}

typedef _UniffiLib_{{ func.name() }}_c = {% match func.return_type() %}{% when Some with (type_) %}{{ type_|ffi_type_name }}{% when None %}Void{% endmatch %} Function({%- call py::arg_list_ffi_decl(func) -%});

typedef _UniffiLib_{{ func.name() }}_d = {% match func.return_type() %}{% when Some with (type_) %}{{ type_|ffi_type_name_dart }}{% when None %}void{% endmatch %} Function({%- call py::arg_list_ffi_decl_dart(func) -%});

final _UniffiLib_{{ func.name() }}_d _UniffiLib_{{ func.name() }}_func = _uniffiLib.lookup<NativeFunction<_UniffiLib_{{ func.name() }}_c>>('{{ func.name() }}').asFunction();

{%- endfor %}

//{# Ensure to call the contract verification only after we defined all functions. -#}
//_uniffi_check_contract_api_version(_UniffiLib)
//_uniffi_check_api_checksums(_UniffiLib)
