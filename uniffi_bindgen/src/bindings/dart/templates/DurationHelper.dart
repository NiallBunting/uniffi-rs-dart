// There is a loss of precision when converting from Rust durations,
// which are accurate to the nanosecond,
// to Python durations, which are only accurate to the microsecond.
class _UniffiConverterDuration extends _UniffiConverterRustBuffer {

    static lift(val) {
      return  val;
    }

    static lower(val) {
      return  val;
    }

    static read(buf) {
        /*seconds = buf.read_u64()
        microseconds = buf.read_u32() / 1.0e3
        return datetime.timedelta(seconds=seconds, microseconds=microseconds)*/
    }

    static write(value, buf) {
        /*seconds = value.seconds + value.days * 24 * 3600
        nanoseconds = value.microseconds * 1000
        if seconds < 0:
            raise ValueError("Invalid duration, must be non-negative")
        buf.write_i64(seconds)
        buf.write_u32(nanoseconds)*/
    }
}
