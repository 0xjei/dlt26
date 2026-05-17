pragma circom 2.1.6;

// IMT MEMBERSHIP + NULLIFIER - Circom reference (not graded)
//
// Optional comparison with the Noir take-home in ../noir/. Not part of submission.
//
// Paste this ENTIRE file into https://zkrepl.dev. It is intentionally
// self-contained: BinaryMerkleRoot is inlined below, so students do not need npm
// or GitHub includes.
//
// What this proves:
//   1. commitment = Poseidon(1)(secret)
//   2. commitment is a leaf under public root
//   3. nullifier = Poseidon(2)(secret, scope)
//
// PUBLIC:  root, scope (inputs) + nullifier (output)
// PRIVATE: secret, depth, leafIndex, siblings, commitment
//
// Do NOT output commitment. It is the Merkle leaf; publishing it links the proof
// to a tree entry and weakens anonymity.

include "circomlib/circuits/poseidon.circom";
include "circomlib/circuits/mux1.circom";
include "circomlib/circuits/comparators.circom";

// BinaryMerkleRoot from zk-kit.circom.
// It recomputes the root from a private leaf, leaf index, depth, and siblings.
// Parent hashes use Poseidon(2), matching the test vector.
template BinaryMerkleRoot(MAX_DEPTH) {
    signal input leaf, depth, index, siblings[MAX_DEPTH];
    signal output out;

    signal nodes[MAX_DEPTH + 1];
    nodes[0] <== leaf;

    signal roots[MAX_DEPTH];
    var root = 0;

    signal indices[MAX_DEPTH] <== Num2Bits(MAX_DEPTH)(index);

    for (var i = 0; i < MAX_DEPTH; i++) {
        var isDepth = IsEqual()([depth, i]);
        roots[i] <== isDepth * nodes[i];
        root += roots[i];

        var c[2][2] = [ [nodes[i], siblings[i]], [siblings[i], nodes[i]] ];
        var childNodes[2] = MultiMux1(2)(c, indices[i]);
        nodes[i + 1] <== Poseidon(2)(childNodes);
    }

    var isDepth = IsEqual()([depth, MAX_DEPTH]);
    out <== root + isDepth * nodes[MAX_DEPTH];
}

// Fixed tree depth 4 for this assignment.
// We avoid a top-level `var DEPTH = 4` because some ZKRepl Circom builds reject it.
template ImtMembershipNullifier() {
    signal input secret;
    signal input scope;
    signal input root;
    signal input depth;
    signal input leafIndex;
    signal input siblings[4];

    signal output nullifier;

    // --- STEP 1: commitment = Poseidon(secret) ---
    // Create a Poseidon(1) component, feed it `secret`, and assign its output to
    // `commitment`. Keep this as an internal signal.
    signal commitment;
    // TODO: component + Poseidon(1); commitment <== hash(secret)

    depth === 4;

    // --- STEP 2: Merkle path -> root ---
    // First constrain depth to the assignment's fixed tree depth. Then
    // instantiate BinaryMerkleRoot(4), use `commitment` as the leaf, wire all
    // four siblings, and constrain the computed root to equal the public `root`.
    // TODO: BinaryMerkleRoot(4)
    //       merkle.leaf <== commitment;
    //       merkle.depth <== depth;
    //       merkle.index <== leafIndex;
    //       merkle.siblings[i] <== siblings[i];
    //       merkle.out === root;

    // --- STEP 3: nullifier = Poseidon(secret, scope) ---
    // This is the only output.
    // TODO: Poseidon(2); nullifier <== hash(secret, scope)
}

// Only root and scope go in public [...]. nullifier is public because it is an
// output signal. Everything else remains private witness data.
component main {public [root, scope]} = ImtMembershipNullifier();

/* INPUT = {
    "secret": "42",
    "scope": "1",
    "root": "5414359685909724592160753026980616548879883398462859248995536406425392954790",
    "depth": "4",
    "leafIndex": "0",
    "siblings": [
        "0",
        "14744269619966411208579211824598458697587494354926760081771325075741142829156",
        "7423237065226347324353380772367382631490014989348495481811164164159255474657",
        "11286972368698509976183087595462810875513684078608517520839298933882497716792"
    ]
} */

// Expected nullifier (public output):
//   16556036937753546091282698062266362651008751416415631538814028886573393469713
//   0x249a628467bd8aee0e896aed253246bad19f524fe2832233cfaf08b5851d6111
// Expected commitment (private witness):
//   12326503012965816391338144612242952408728683609716147019497703475006801258307
//   0x1b408dafebeddf0871388399b1e53bd065fd70f18580be5cdde15d7eb2c52743
