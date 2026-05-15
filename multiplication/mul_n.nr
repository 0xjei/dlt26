// MULTIPLICATION CIRCUIT (N)
// Prove that you know all inputs such that their product = out
// without revealing any of the inputs.
//
// Private inputs: all elements of inputs
// Public output:  out

fn multiply_n(inputs: Vec<Field>) -> Field {
    let mut result = inputs.get(0);
    for i in 1..inputs.len() as u32 {
        result = result * inputs.get(i);
    }
    result
}

fn main(inputs: [Field; 4]) -> pub Field {
    // Vec not allowed in main, convert fixed array inside
    let mut v: Vec<Field> = Vec::new();
    for i in 0..4 {
        v.push(inputs[i]);
    }
    multiply_n(v)
}

// Prover.toml
// inputs = ["5", "6", "7", "2"]