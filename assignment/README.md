# Take-home: IMT Membership + Nullifier (Noir)

## Goal

Write a Noir circuit that does three things:

1. Computes `commitment = Poseidon(secret)`.
2. Proves `commitment` is a leaf in an Incremental Merkle Tree by verifying a Merkle path against a public root.
3. Returns `nullifier = Poseidon(secret, scope)` to prevent double signaling.

You do not need to build or reconstruct the tree. The tree is built off-circuit. You receive the root (public) and your Merkle path (private) as inputs — your job is to verify the path and produce the nullifier.

## Why This Matters

This is the core idea behind Semaphore-style membership proofs: prove "I know a secret whose commitment is in this Merkle tree" without revealing the secret, the commitment, the leaf index, or the Merkle path.

The nullifier adds anti-double-signaling. `scope` is a public input that binds the nullifier to a specific context — a poll, a vote, an action. The circuit outputs:

```
nullifier = Poseidon(secret, scope)
```

Same secret, same scope → same nullifier. The verifier stores it and rejects if seen before.
Same secret, different scope → different nullifier. Nothing links them.

## Files

- `noir/imt_membership.nr` — blueprint with TODOs (your submission starts here).

## Circuit Contract

**Public inputs:**

- `root` — the Merkle tree root
- `scope` — the context identifier (e.g. poll ID)

**Private inputs:**

- `secret` — your secret value
- `depth` — number of levels in the tree (constrain to `4`)
- `leaf_index` — your leaf position in the tree
- `sibling_0` … `sibling_3` — sibling hashes along your Merkle path (flattened for the playground)

**Public output:**

- `nullifier` (`-> pub Field` in `main`)

**Do not make `commitment` public.** It is the Merkle leaf and must stay private — revealing it would allow linking your proof to your identity across contexts.

The assignment uses a fixed depth of `4`. Your circuit must constrain the witness `depth` to match (the blueprint already includes one `assert` — do not remove it).

## Dependencies

The blueprint already imports `poseidon` and `binary_merkle_root`, and defines `poseidon_hash_2` for parent nodes. For local `nargo`, add the same dependencies to `Nargo.toml` (versions are in the comments at the top of `noir/imt_membership.nr`).

## Test Vector

Use these values to verify your circuit is correct.

**Public inputs:**

- `scope`: `1` (`0x01`)
- `root`: `5414359685909724592160753026980616548879883398462859248995536406425392954790`
- `root` hex: `0xbf86b427d776edf4e5dca79e460032043d7fdcfff5175a8778f8da3f874bda6`

**Private inputs:**

- `secret`: `42` (`0x2a`)
- `depth`: `4`
- `leaf_index`: `0`
- `sibling_0`: `0` (`0x00`)
- `sibling_1`: `14744269619966411208579211824598458697587494354926760081771325075741142829156` (`0x2098f5fb9e239eab3ceac3f27b81e481dc3124d55ffed523a839ee8446b64864`)
- `sibling_2`: `7423237065226347324353380772367382631490014989348495481811164164159255474657` (`0x1069673dcdb12263df301a6ff584a7ec261a44cb9dc68df067a4774460b1f1e1`)
- `sibling_3`: `11286972368698509976183087595462810875513684078608517520839298933882497716792` (`0x18f43331537ee2af2e3d758d50f72106467c6eea50371dd528d57eb2b856d238`)

**Expected public output:**

- `nullifier`: `16556036937753546091282698062266362651008751416415631538814028886573393469713`
- `nullifier` hex: `0x249a628467bd8aee0e896aed253246bad19f524fe2832233cfaf08b5851d6111`

**Debug value (private — do not return from `main`):**

- `commitment`: `12326503012965816391338144612242952408728683609716147019497703475006801258307`
- `commitment` hex: `0x1b408dafebeddf0871388399b1e53bd065fd70f18580be5cdde15d7eb2c52743`

## Hints

Work in `noir/imt_membership.nr` — fill the three `TODO` blocks. Do not copy from `assignment/circom/` (reference only).

### Step 1 — Commitment

- Reuse the **one-input Poseidon** pattern from `membership/noir/` (`commitment = hash_1(secret)`).
- The result is a private `Field`, not a public input or return value (unlike the warm-up, where commitments are public inputs).

### Step 2 — Merkle root

- **New in the assignment:** replace the warm-up’s list check with Merkle path verification.
- The Merkle **leaf** is `commitment`, not `secret`.
- `leaf_index` must become **four little-endian bits** (path left/right at each level).
- Build a sibling array from `sibling_0` … `sibling_3` (already done in `main` — pass it through).
- Call `binary_merkle_root` with depth `4`, your parent hasher (`poseidon_hash_2`), the leaf, `depth`, the bits, and the siblings. Check the crate signature if the playground complains about argument order.
- Constrain the gadget output against the public `root` with `assert(...)`.

### Step 3 — Nullifier

- Reuse the **two-input Poseidon** pattern from `membership/noir/` (`secret` and `scope`).
- Return that value from `imt_membership_nullifier`; `main` already exposes it as the public output.

### Stuck?

1. Compare visibility: only `root` and `scope` are `pub` in `main`.
2. Run the test inputs in the comments at the bottom of the blueprint (use **hex**).
3. If the nullifier matches but Merkle fails, your leaf or siblings are wrong — not the nullifier step.

## Running

Paste `noir/imt_membership.nr` into [Noir Playground](https://play.noir-lang.org). Use **hex** for large field elements — bare decimals are parsed as JS floats and break.

Mark only `root` and `scope` as `pub` in `main`. The return type is the public `nullifier`.

## Common Mistakes

- Making `commitment` public or returning it from `main`.
- Passing `secret` into the Merkle gadget instead of `commitment`.
- Forgetting `assert(depth == 4)`.
- Reversing the nullifier inputs — use `[secret, scope]`, not `[scope, secret]`.
- Hashing the leaf with two inputs — use `hash_1` for commitment, `hash_2` for parents and nullifier.
- Pasting large field decimals into the playground — use hex.

## Submit

Share a working circuit via **Noir Playground** (share button) and send the link directly.

Reference solution (after you submit): `solutions/noir/imt_membership.nr` — only if that folder is published on your course branch.
