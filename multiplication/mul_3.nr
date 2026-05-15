// MULTIPLICATION CIRCUIT (3)
// Prove that you know a and b such that a * b * c = out
// without revealing a and b.
//
// Private inputs: a, b
// Public inputs:  c, out

fn multiply_3(a: Field, b: Field, c: Field) -> Field {
    // hint: noir handles decomposition for you
    // unlike circom you do not need intermediate signals
    a * b * c
}

fn main(a: Field, b: Field, c: pub Field) -> pub Field {
    multiply_3(a, b, c)
}

// Prover.toml
// a = "5"
// b = "6"
// c = "7"