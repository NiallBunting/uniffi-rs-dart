// There is a loss of precision when converting from Rust durations,
// which are accurate to the nanosecond,
// to Python durations, which are only accurate to the microsecond.
class _UniffiConverterDuration extends _UniffiConverterRustBuffer {
    static lift(val) {
      return  val;
    }

    lower(val) {
      return  val;
    }
}
