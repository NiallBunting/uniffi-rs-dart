{#
// Template to call into rust. Used in several places.
// Variable names in `arg_list_decl` should match up with arg lists
// passed to rust via `arg_list_lowered`
#}

{%- macro to_ffi_call(func, rustStatus) -%}
    {%- match func.throws_type() -%}
    {%- when Some with (e) -%}
_rustCallWithError({{ e|ffi_converter_name }}(),
    {%- else -%}
_rustCall(
    {%- endmatch -%}
    () => _UniffiLib_{{ func.ffi_func().name() }}_func({%- call arg_list_lowered(func, rustStatus) -%}),
    {{ rustStatus }}
)
{%- endmacro -%}

{%- macro to_ffi_call_with_prefix(prefix, func, rustStatus) -%}
    {%- match func.throws_type() -%}
    {%- when Some with (e) -%}
_rustCallWithError(
    {{ e|ffi_converter_name }}(),
    {%- else -%}
_rustCall(
    {%- endmatch -%}
    () => _UniffiLib_{{ func.ffi_func().name() }}_func({{- prefix }}, {%- call arg_list_lowered(func, rustStatus) -%}),
    {{ rustStatus }}
)
{%- endmacro -%}

{%- macro arg_list_lowered(func, rustStatus) %}
    {%- for arg in func.arguments() %}
        {{ arg|lower_fn }}({{ arg.name()|var_name }}),
    {%- endfor %}
    {{ rustStatus }}
{%- endmacro -%}

{#-
// Arglist as used in Python declarations of methods, functions and constructors.
// Note the var_name and type_name filters.
-#}

{% macro arg_list_decl(func) %}
    {%- for arg in func.arguments() -%}
        {%- match arg.default_value() -%} {%- when Some with(literal) -%}: "typing.Union[object, {{ arg|type_name -}}]" = _DEFAULT {%- else -%}{{- arg|type_name }}{%- endmatch %} {{ arg.name()|var_name -}}{%- if !loop.last %},{% endif -%}
    {%- endfor %}
{%- endmacro %}

{#-
// Arglist as used in the _UniffiLib function declarations.
// Note unfiltered name but ffi_type_name filters.
-#}
{%- macro arg_list_ffi_decl(func) %}
    {%- for arg in func.arguments() %}
    {{ arg.type_().borrow()|ffi_type_name }},
    {%- endfor %}
    {%- if func.has_rust_call_status_arg() %}
    Pointer<_UniffiRustCallStatus>,{% endif %}
{% endmacro -%}

{%- macro arg_list_ffi_decl_dart(func) %}
    {%- for arg in func.arguments() %}
    {{ arg.type_().borrow()|ffi_type_name_dart }},
    {%- endfor %}
    {%- if func.has_rust_call_status_arg() %}
    Pointer<_UniffiRustCallStatus>,{% endif %}
{% endmacro -%}

{#
 # Setup function arguments by initializing default values.
 #}
{%- macro setup_args(func) %}
    {%- for arg in func.arguments() %}
    {%- match arg.default_value() %}
    {%- when None %}
    {%- when Some with(literal) %}
    if {{ arg.name()|var_name }} is _DEFAULT:
        {{ arg.name()|var_name }} = {{ literal|literal_py(arg.as_type().borrow()) }}
    {%- endmatch %}
    {% endfor -%}
{%- endmacro -%}

{#
 # Create a rustCallback
 #}
{%- macro create_rust_callback() %}
final Pointer<_UniffiRustCallStatus> _rustCallStatus = calloc<_UniffiRustCallStatus >();
{%- endmacro -%}

{#
 # Macro to call methods
 #}
{%- macro method_decl(py_method_name, meth) %}
{%  if meth.is_async() %}

    {%- match meth.return_type() -%}
    {%- when Some with (return_type) -%}Future<{{- return_type|type_name -}}>{%- when None -%}void {%- endmatch %} {{ py_method_name }}({% call arg_list_decl(meth) %}) async {
        {%- call setup_args(meth) %}

        return _rustCallAsync(
            // This doesn't need rust call status
            _UniffiLib_{{ meth.ffi_func().name() }}_func (
                _pointer, {% call arg_list_lowered(meth, "") %}
            ),/*
            _pointer,
            _UniffiLib.{{ meth.ffi_rust_future_poll(ci) }},
            _UniffiLib.{{ meth.ffi_rust_future_complete(ci) }},
            _UniffiLib.{{ meth.ffi_rust_future_free(ci) }},*/
            // lift function
            {%- match meth.return_type() %}
            {%- when Some(return_type) %}
            {{ return_type|lift_fn }},
            {%- when None %}
            () => {},
            {% endmatch %}
            // Error FFI converter
            {%- match meth.throws_type() %}
            {%- when Some(e) %}
            {{ e|ffi_converter_name }}(),
            {%- when None %}
            null,
            {%- endmatch %}
        );
    }

{%- else -%}
{%-     match meth.return_type() %}
{%-         when Some with (return_type) %}
    // method: 2
    {{ return_type|type_name }} {{ py_method_name }}({% call arg_list_decl(meth) %}) {
        {%- call setup_args(meth) %}

        {%- call create_rust_callback() %}
        return {{ return_type|lift_fn }}(
            {% call to_ffi_call_with_prefix("_pointer", meth, "_rustCallStatus") %}
        );
    }
{%-         when None %}
    // method: 3
    {{ py_method_name }}({% call arg_list_decl(meth) %}){
        {%- call setup_args(meth) -%}
        {%- call create_rust_callback() %}
        {% call to_ffi_call_with_prefix("_pointer", meth, "_rustCallStatus") %};
    }
{%      endmatch %}
{%  endif %}

{% endmacro %}
