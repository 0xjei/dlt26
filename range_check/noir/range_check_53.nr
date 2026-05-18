// RANGE CHECK 53 bits (Field witness)
// Prove that a secret value lies in [0, 2^53) without revealing it.
//
// Private input: value (Field; must fit in 53 bits as an integer)

fn range_check_53(value: Field) {
    value.assert_max_bit_size::<53>();
}

fn main(value: Field) {
    range_check_53(value);
}

// Prover.toml
// value = "42"
