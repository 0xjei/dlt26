// IMT MEMBERSHIP + NULLIFIER - ASSIGNMENT BLUEPRINT (Noir)
//
// Prove:
//   1. commitment = Poseidon(secret)
//   2. commitment is a leaf in the Merkle tree with public root (private path)
//   3. nullifier = Poseidon(secret, scope)
//
// Private:  secret, depth, leaf_index bits, siblings
// Public:   root, scope
// Output:   nullifier
//
// Add to Nargo.toml:
// [dependencies]
// poseidon = { tag = "v0.1.1", git = "https://github.com/noir-lang/poseidon" }
// binary_merkle_root = { git = "https://github.com/zk-kit/zk-kit.noir", tag = "binary-merkle-root-v0.0.1", directory = "packages/binary-merkle-root" }

use poseidon::poseidon::bn254;
use binary_merkle_root::binary_merkle_root;

fn poseidon_hash_2(input: [Field; 2]) -> Field {
    bn254::hash_2(input)
}

fn imt_membership_nullifier(
    secret: Field,
    scope: Field,
    root: Field,
    depth: u32,
    leaf_index: Field,
    siblings: [Field; 4],
) -> Field {
    // --- STEP 1: commitment = Poseidon(secret) ---
    // Compute the Merkle leaf inside the circuit. Keep it private.
    let commitment: Field = 0; // TODO: bn254::hash_1([secret])

    // --- STEP 2: Merkle path -> root ---
    // First constrain depth to the assignment's fixed tree depth. Then use
    // `commitment` as the leaf, convert leaf_index to little-endian bits, and
    // verify the computed root equals the public `root`.
    assert(depth == 4);
    let computed_root: Field = 0; // TODO: binary_merkle_root or manual walk
    assert(computed_root == root);

    // --- STEP 3: nullifier = Poseidon(secret, scope) ---
    // This is the only public output.
    let nullifier: Field = 0; // TODO: bn254::hash_2([secret, scope])

    nullifier
}

// main: mark ONLY root and scope as pub; everything else stays private.
fn main(
    secret: Field,           // private
    scope: pub Field,        // PUBLIC INPUT
    root: pub Field,         // PUBLIC INPUT
    depth: Field,            // private
    leaf_index: Field,       // private
    sibling_0: Field,        // private
    sibling_1: Field,        // private
    sibling_2: Field,        // private
    sibling_3: Field,        // private
) -> pub Field {            // PUBLIC OUTPUT: nullifier
    imt_membership_nullifier(
        secret,
        scope,
        root,
        depth as u32,
        leaf_index,
        [sibling_0, sibling_1, sibling_2, sibling_3],
    )
}

// TEST INPUT (secret=42, scope=1, depth=4, leaf at index 0) - use hex in Playground:
//   secret      = 0x2a
//   scope       = 0x01          (PUBLIC)
//   root        = 0xbf86b427d776edf4e5dca79e460032043d7fdcfff5175a8778f8da3f874bda6  (PUBLIC)
//   depth       = 4
//   leaf_index  = 0
//   sibling_0   = 0x00
//   sibling_1   = 0x2098f5fb9e239eab3ceac3f27b81e481dc3124d55ffed523a839ee8446b64864
//   sibling_2   = 0x1069673dcdb12263df301a6ff584a7ec261a44cb9dc68df067a4774460b1f1e1
//   sibling_3   = 0x18f43331537ee2af2e3d758d50f72106467c6eea50371dd528d57eb2b856d238
// Expected nullifier output: 0x249a628467bd8aee0e896aed253246bad19f524fe2832233cfaf08b5851d6111