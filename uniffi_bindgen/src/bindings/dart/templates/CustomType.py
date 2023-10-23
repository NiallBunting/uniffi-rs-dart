{%- match python_config.custom_types.get(name.as_str())  %}
{% when None %}
{#- No custom type config, just forward all methods to our builtin type #}
# Type alias
{{ name }} = {{ builtin|type_name }}

class _UniffiConverterType{{ name }} {
    static write(value, buf) {
        {{ builtin|ffi_converter_name }}.write(value, buf)
    }

    static read(buf) {
        return {{ builtin|ffi_converter_name }}.read(buf)
    }

    static lift(value) {
        return {{ builtin|ffi_converter_name }}.lift(value)
    }

    static lower(value) {
        return {{ builtin|ffi_converter_name }}.lower(value)
    }
}

{%- when Some(config) %}

{%- match config.imports %}
{%- when Some(imports) %}
{%- for import_name in imports %}
{{ self.add_import(import_name) }}
{%- endfor %}
{%- else %}
{%- endmatch %}

# Type alias
{{ name }} = {{ builtin|type_name }}

{#- Custom type config supplied, use it to convert the builtin type #}
class _UniffiConverterType{{ name }} {
    static write(value, buf) {
        builtin_value = {{ config.from_custom.render("value") }}
        {{ builtin|write_fn }}(builtin_value, buf)
    }

    static read(buf) {
        builtin_value = {{ builtin|read_fn }}(buf)
        return {{ config.into_custom.render("builtin_value") }}
    }

    static lift(value) {
        builtin_value = {{ builtin|lift_fn }}(value)
        return {{ config.into_custom.render("builtin_value") }}
    }

    static lower(value) {
        builtin_value = {{ config.from_custom.render("value") }}
        return {{ builtin|lower_fn }}(builtin_value)
    }
}
{%- endmatch %}
