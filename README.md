# DLT School 2026 — ZK circuits (Circom & Noir)

Course materials for building and understanding zero-knowledge circuits. Each topic has parallel **Circom** and **Noir** files under `circom/` and `noir/` subfolders.

## Repository layout

```
dlt26/
├── multiplication/
│   ├── circom/          mul_2.circom, mul_3.circom, mul_n.circom
│   └── noir/            mul_2.nr, mul_3.nr, mul_n.nr
├── range_check/
│   ├── circom/          range_check.circom
│   └── noir/            range_check.nr
├── membership/
│   ├── circom/          membership.circom, compute_poseidon_util.circom
│   └── noir/            membership.nr, compute_poseidon2_util.nr
└── assignment/          # take-home (submit Noir only)
    ├── noir/            imt_membership.nr   ← blueprint
    ├── circom/          imt_membership.circom   (optional comparison, not graded)
    └── solutions/       on `solution` branch only (not on student `main`)
        └── noir/
```

## Suggested order

| Step | Circom | Noir | What you learn |
|------|--------|------|----------------|
| 1 | `multiplication/circom/` | `multiplication/noir/` | Constraints, public vs private |
| 2 | `range_check/circom/` | `range_check/noir/` | Bit/range bounds |
| 3 | `membership/circom/` | `membership/noir/` | Commitment, **list** membership, nullifier |
| 4 | — | `assignment/noir/` | Same commitment + nullifier; **add** Merkle path vs public `root` |

Step 3 publishes a list of commitments; step 4 replaces that with a Merkle tree and a single public `root`.

## How to run

- **Circom (in-class):** open files under `*/circom/` in [zkrepl.dev](https://zkrepl.dev).
- **Noir (in-class + assignment):** open files under `*/noir/` in [Noir Playground](https://www.noir-playground.app/). Use hex for large field elements.

Take-home: [`assignment/README.md`](./assignment/README.md) — **Noir only** (`assignment/noir/imt_membership.nr`).

## AI tutor (hints only)

Use the **`zk-circuit-tutor`** skill (`SKILL.md` in this repo). It explains concepts and gives progressive hints; it does not complete TODOs or hand you the take-home via the Circom reference.

## License

See [`LICENSE`](./LICENSE).
