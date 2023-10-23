class {{ protocol_name }}(typing.Protocol) {
    {%- for meth in methods.iter() %}
    {{ meth.name()|fn_name }}(self, {% call py::arg_list_decl(meth) %}) {
        raise NotImplementedError
    }
    {%- else %}
    {%- endfor %}
}
