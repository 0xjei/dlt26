// RANGE CHECK 32 bits
// Prove that a secret value lies in [0, 2^32) without revealing it.
//
// Private input: value

fn range_check_32(value: u32) {
    let _ = value;
}

fn main(value: u32) {
    range_check_32(value);
}

// Prover.toml
// value = "42"
