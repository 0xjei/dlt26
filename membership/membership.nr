// MEMBERSHIP CIRCUIT (Noir port of membership.circom)
//
// Private input:  secret
// Public inputs:  commitments[N]
// Public output:  commitment = Poseidon(secret)

// Import the Poseidon hash function from the Noir std library.
// Note: This must go in the Nargo.toml file.
//
// [dependencies]
// poseidon = { tag = "v0.1.1", git = "https://github.com/noir-lang/poseidon" }

use poseidon::poseidon::bn254;

global N: u32 = 4;

fn membership(secret: Field, commitments: [Field; N]) -> Field {
    // Comments are the Circom code for the same circuit.
    // component poseidon = Poseidon(1);
    // poseidon.inputs[0] <== secret;
    // commitment <== poseidon.out;
    let commitment = bn254::hash_1([secret]);

    // component isEqual[N]; signal matches[N]; signal sum[N+1];
    // sum[0] <== 0;
    let mut sum: Field = 0;
    for i in 0..N {
        // isEqual[i].in[0] <== commitment;
        // isEqual[i].in[1] <== commitments[i];
        // matches[i] <== isEqual[i].out;
        let matches = (commitment == commitments[i]) as Field;
        // sum[i+1] <== sum[i] + matches[i];
        sum = sum + matches;
    }

    // sum[N] === 1;
    assert(sum == 1);

    commitment
}

// component main {public [commitments]} = Membership(4);
//
// Flattened public inputs just for the Noir Playground.
// Use hex for large Fields, bare decimals become JS floats (e.g. 8.64e+75) and fail parsing.
//
// Playground inputs (secret=42):
//   secret         = 0x2a  (or 42)
//   commitment_0   = 0x131d73cf6b30079aca0dff6a561cd0ee50b540879abe379a25a06b24bde2bebd
//   commitment_1   = 0x2778f900758cc46e051040641348de3dacc6d2a31e2963f22cbbfb8f65464241
//   commitment_2   = 0xb7ebc53ddde5fb3b9de1913f1d819d0b9fab90a101da7ee2dc9b36a5c1fbb9a
//   commitment_3   = 0x1b408dafebeddf0871388399b1e53bd065fd70f18580be5cdde15d7eb2c52743
fn main(
    secret: Field,
    commitment_0: pub Field,
    commitment_1: pub Field,
    commitment_2: pub Field,
    commitment_3: pub Field,
) -> pub Field {
    membership(secret, [commitment_0, commitment_1, commitment_2, commitment_3])
}
