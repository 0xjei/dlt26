// MULTIPLICATION CIRCUIT (2)
// Prove that you know a such that a * b = out
// without revealing a.
//
// Private input: a
// Public inputs: b, out

fn multiply_2(a: Field, b: Field) -> Field {
    a * b
}

fn main(a: Field, b: pub Field) -> pub Field {
    multiply_2(a, b)
}

// Prover.toml
// a = "5"
// b = "6"