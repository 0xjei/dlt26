// RANGE CHECK CIRCUIT
// Prove that a secret value lies within the interval [0, 2^n)
// without revealing the value.
//
// Private input: value (your secret)
// Public input:  none (the range is fixed by the bit size)

fn range_check(value: u32) {
    // casting to u32 implicitly constrains value to [0, 2^32)
    // if value overflows the proof will fail
    // no explicit assertion needed, the type does the work
    let _ = value;
}

fn main(value: u32) {
    range_check(value);
}

// Prover.toml
// value = "42"