// This file was autogenerated by some hot garbage in the `uniffi` crate.
// Trust me, you don't want to mess with it!
//
// Common helper code.
//
// Ideally this would live in a separate .dart file where it can be unittested etc
// in isolation, and perhaps even published as a re-useable package.
//
// However, it's important that the details of how this helper code works (e.g. the
// way that different builtin types are passed across the FFI) exactly match what's
// expected by the rust code on the other side of the interface. In practice right
// now that means coming from the exact some version of `uniffi` that was used to
// compile the rust component. The easiest way to ensure this is to bundle the Python
// helpers directly inline like we're doing here.

import 'dart:ffi';
import 'package:ffi/ffi.dart';


{%- if ci.has_async_fns() %}
{%- endif %}

{%- for req in self.imports() %}
{{ req.render() }}
{%- endfor %}

// Used for default argument values
//_DEFAULT = object()

{% include "RustBufferTemplate.dart" %}
{% include "Helpers.dart" %}
{% include "RustBufferHelper.dart" %}

// Contains loading, initialization code, and the FFI Function declarations.
{% include "NamespaceLibraryTemplate.dart" %}

{%- if ci.has_async_fns() %}
{%- include "Async.dart" %}
{%- endif %}

// Public interface members begin here.
{{ type_helper_code }}

{%- for func in ci.function_definitions() %}
{%- include "TopLevelFunctionTemplate.py" %}
{%- endfor %}

{% import "macros.dart" as py %}
