{#
# Python has a built-in `enum` module which is nice to use, but doesn't support
# variants with associated data. So, we switch here, and generate a stdlib `enum`
# when none of the variants have associated data, or a generic nested-class
# construct when they do.
#}
{% if e.is_flat() %}

// Enumtemplate: 1
enum {{ type_name }} {
    _,
    {% for variant in e.variants() -%}
    {{ variant.name()|enum_variant_py }},
    {% endfor %}
}
{% else %}

// Generated by: EnumTemplate: 2
enum {{ type_name }} {

    // Each enum variant is a nested class of the enum itself.
    _,
    {% for variant in e.variants() -%}
    {{ variant.name()|enum_variant_py }},

    {% endfor %}


/*

    {% for variant in e.variants() -%}
        {% for field in variant.fields() %}
    final {{ field|type_name }} {{ field.name()|var_name }};
        {%- endfor %}
    {% endfor %}



    {% for variant in e.variants() -%}
    class {{ variant.name()|enum_variant_py }}:
        {% for field in variant.fields() %}
        {%- endfor %}

        @typing.no_type_check
        def __init__(self,{% for field in variant.fields() %}{{ field.name()|var_name }}: "{{- field|type_name }}"{% if loop.last %}{% else %}, {% endif %}{% endfor %}):
            {% if variant.has_fields() %}
            {%- for field in variant.fields() %}
            self.{{ field.name()|var_name }} = {{ field.name()|var_name }}
            {%- endfor %}
            {% else %}
            pass
            {% endif %}

        def __str__(self):
            return "{{ type_name }}.{{ variant.name()|enum_variant_py }}({% for field in variant.fields() %}{{ field.name()|var_name }}={}{% if loop.last %}{% else %}, {% endif %}{% endfor %})".format({% for field in variant.fields() %}self.{{ field.name()|var_name }}{% if loop.last %}{% else %}, {% endif %}{% endfor %})

        def __eq__(self, other):
            if not other.is_{{ variant.name()|var_name }}():
                return False
            {%- for field in variant.fields() %}
            if self.{{ field.name()|var_name }} != other.{{ field.name()|var_name }}:
                return False
            {%- endfor %}
            return True
    {% endfor %}


*/

}

{% endif %}

// Generated By: EnumTemplate: 3
class {{ ffi_converter_name }} extends _UniffiConverterRustBuffer<{{type_name}}> {
    read(_UniffiRustBufferBuilder buf) {
        var variant = buf.read_i32();

        {%- for variant in e.variants() %}
        if (variant == {{ loop.index }}) {
            {%- if e.is_flat() %}
            return {{ type_name }}.{{variant.name()|enum_variant_py}};
            {%- else %}
                // This should be in the enum, but read it for now
                ({%- for field in variant.fields() %}
                {{ field|read_fn }}(buf),
                {%- endfor %});

            return {{ type_name }}.{{variant.name()|enum_variant_py}};
            {%- endif %}
        }
        {%- endfor %}
        throw "Raw enum value doesn't match any cases";
   }

    write(_UniffiRustBufferBuilder buf, {{ type_name }} value) {
        {%- for variant in e.variants() %}
        {%- if e.is_flat() %}
        if (value == {{ type_name }}.{{ variant.name()|enum_variant_py }}) {
            buf.write_i32({{ loop.index }});
        }
        {%- else %}
        if (value == {{ type_name }}.{{ variant.name()|enum_variant_py }}) {
            buf.write_i32({{ loop.index }});
            {%- for field in variant.fields() %}
            //{{ field|write_fn }}(value.{{ field.name()|var_name }}, buf);
            {%- endfor %}
        }
        {%- endif %}
        {%- endfor %}
    }
}
