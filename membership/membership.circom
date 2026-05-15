pragma circom 2.1.6;

include "circomlib/circuits/poseidon.circom";
include "circomlib/circuits/comparators.circom";

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

component main {public [commitments]} = Membership(4);

/* INPUT = {
    "secret": "42",
    "commitments": [
        "8645981980787649023086883978738420856660271013038108762834452721572614684349",
        "17853941289740592551682164141790101668489478619664963356488634739728685875777",
        "5199363853932272446084541931873785938987820779897294035064941545455873932186",
        "12326503012965816391338144612242952408728683609716147019497703475006801258307"
    ]
} */