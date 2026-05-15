// POSEIDON2 HASH (1 input)
// Hash a single public field with Poseidon2 (Noir std sponge).
//
// Public input:  in
// Public output: out

// Add to Nargo.toml:
// [dependencies]
// poseidon = { tag = "v0.1.1", git = "https://github.com/noir-lang/poseidon" }

use poseidon::poseidon::bn254;

fn main(secret: pub Field) -> pub Field {
    bn254::hash_1([secret])
}

// Prover.toml
// input = "9"
