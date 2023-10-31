// There is a loss of precision when converting from Rust durations,
// which are accurate to the nanosecond,
// to Python durations, which are only accurate to the microsecond.
class _UniffiConverterDuration extends _UniffiConverterRustBuffer {

    read(_UniffiRustBufferBuilder buf) {
       return buf;
    }

    write(_UniffiRustBufferBuilder buf, value) {
       return buf;
    }
}
