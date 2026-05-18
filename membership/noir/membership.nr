// MEMBERSHIP + NULLIFIER
// Prove that you know a secret whose Poseidon commitment appears in a public
// list, without revealing the secret or which entry matched. Return only a
// scope-bound nullifier (commitment stays private).
//
// Teaches: hash_1 commitment, set membership (sum of equals), hash_2 nullifier.
// Assignment adds Merkle path verification under a public root instead of a list.
//
// Private:  secret
// Public:   commitment_0..commitment_3, scope
// Output:   nullifier
//
// Add to Nargo.toml:
// [dependencies]
// poseidon = { tag = "v0.1.1", git = "https://github.com/noir-lang/poseidon" }

use poseidon::poseidon::bn254;

global N: u32 = 4;

fn membership(secret: Field, commitments: [Field; N]) {
    let commitment = bn254::hash_1([secret]);

    let mut sum: Field = 0;
    for i in 0..N {
        let matches = (commitment == commitments[i]) as Field;
        sum = sum + matches;
    }
    assert(sum == 1);
}

fn membership_nullifier(secret: Field, commitments: [Field; N], scope: Field) -> Field {
    membership(secret, commitments);
    bn254::hash_2([secret, scope])
}

fn main(
    secret: Field,
    scope: pub Field,
    commitment_0: pub Field,
    commitment_1: pub Field,
    commitment_2: pub Field,
    commitment_3: pub Field,
) -> pub Field {
    membership_nullifier(
        secret,
        [commitment_0, commitment_1, commitment_2, commitment_3],
        scope,
    )
}

// Playground (secret=42, scope=1; commitment_3 is Poseidon(secret)):
//   secret         = 0x2a
//   scope          = 0x01          (PUBLIC)
//   commitment_0   = 0x131d73cf6b30079aca0dff6a561cd0ee50b540879abe379a25a06b24bde2bebd
//   commitment_1   = 0x2778f900758cc46e051040641348de3dacc6d2a31e2963f22cbbfb8f65464241
//   commitment_2   = 0xb7ebc53ddde5fb3b9de1913f1d819d0b9fab90a101da7ee2dc9b36a5c1fbb9a
//   commitment_3   = 0x1b408dafebeddf0871388399b1e53bd065fd70f18580be5cdde15d7eb2c52743
// Expected nullifier: 0x249a628467bd8aee0e896aed253246bad19f524fe2832233cfaf08b5851d6111
