// MEMBERSHIP + NULLIFIER CIRCUIT
// Prove that you know a secret whose Poseidon commitment appears in a public
// list, without revealing the secret or which list entry matched. Also expose
// a nullifier derived from the secret and a public scope, so the same identity
// cannot be used twice in that scope.
//
// Private input:  secret
// Public inputs:  commitment_0..commitment_{N-1}, external_nullifier
// Public outputs: commitment (= Poseidon(secret)), nullifier (= Poseidon(secret, external_nullifier))
//
// Add to Nargo.toml:
// [dependencies]
// poseidon = { tag = "v0.1.1", git = "https://github.com/noir-lang/poseidon" }

use poseidon::poseidon::bn254;

global N: u32 = 4;

fn membership(secret: Field, commitments: [Field; N]) -> Field {
    let commitment = bn254::hash_1([secret]);

    let mut sum: Field = 0;
    for i in 0..N {
        let matches = (commitment == commitments[i]) as Field;
        sum = sum + matches;
    }
    assert(sum == 1);

    commitment
}

fn membership_nullifier(
    secret: Field,
    commitments: [Field; N],
    external_nullifier: Field,
) -> (Field, Field) {
    let commitment = membership(secret, commitments);
    let nullifier = bn254::hash_2([secret, external_nullifier]);
    (commitment, nullifier)
}

fn main(
    secret: Field,
    external_nullifier: pub Field,
    commitment_0: pub Field,
    commitment_1: pub Field,
    commitment_2: pub Field,
    commitment_3: pub Field,
) -> pub (Field, Field) {
    membership_nullifier(
        secret,
        [commitment_0, commitment_1, commitment_2, commitment_3],
        external_nullifier,
    )
}

// Playground (secret=42, external_nullifier=1):
//   secret               = 0x2a
//   external_nullifier   = 0x01
//   commitment_0         = 0x131d73cf6b30079aca0dff6a561cd0ee50b540879abe379a25a06b24bde2bebd
//   commitment_1         = 0x2778f900758cc46e051040641348de3dacc6d2a31e2963f22cbbfb8f65464241
//   commitment_2         = 0xb7ebc53ddde5fb3b9de1913f1d819d0b9fab90a101da7ee2dc9b36a5c1fbb9a
//   commitment_3         = 0x1b408dafebeddf0871388399b1e53bd065fd70f18580be5cdde15d7eb2c52743
