pragma circom 2.1.6;

include "circomlib/circuits/poseidon.circom";
include "circomlib/circuits/comparators.circom";

// MEMBERSHIP + NULLIFIER CIRCUIT
// Prove that you know a secret whose Poseidon commitment appears in a public
// list, without revealing the secret or which list entry matched. Also expose
// a nullifier derived from the secret and a public scope, so the same identity
// cannot be used twice in that scope.
//
// Private input:  secret
// Public inputs:  commitments[N], external_nullifier
// Public outputs: commitment (= Poseidon(secret)), nullifier (= Poseidon(secret, external_nullifier))

template Membership(N) {
    signal input secret;
    signal input commitments[N];
    signal output commitment;

    component poseidon = Poseidon(1);
    poseidon.inputs[0] <== secret;
    commitment <== poseidon.out;

    component isEqual[N];
    signal matches[N];
    signal sum[N+1];

    sum[0] <== 0;
    for (var i = 0; i < N; i++) {
        isEqual[i] = IsEqual();
        isEqual[i].in[0] <== commitment;
        isEqual[i].in[1] <== commitments[i];
        matches[i] <== isEqual[i].out;
        sum[i+1] <== sum[i] + matches[i];
    }

    sum[N] === 1;
}

template MembershipNullifier(N) {
    signal input secret;
    signal input commitments[N];
    signal input external_nullifier;
    signal output commitment;
    signal output nullifier;

    component membership = Membership(N);
    membership.secret <== secret;
    for (var i = 0; i < N; i++) {
        membership.commitments[i] <== commitments[i];
    }
    commitment <== membership.commitment;

    component nullifierHash = Poseidon(2);
    nullifierHash.inputs[0] <== secret;
    nullifierHash.inputs[1] <== external_nullifier;
    nullifier <== nullifierHash.out;
}

component main {public [commitments, external_nullifier]} = MembershipNullifier(4);

/* INPUT = {
    "secret": "42",
    "external_nullifier": "1",
    "commitments": [
        "8645981980787649023086883978738420856660271013038108762834452721572614684349",
        "17853941289740592551682164141790101668489478619664963356488634739728685875777",
        "5199363853932272446084541931873785938987820779897294035064941545455873932186",
        "12326503012965816391338144612242952408728683609716147019497703475006801258307"
    ]
} */
