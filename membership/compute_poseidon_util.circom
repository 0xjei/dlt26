pragma circom 2.1.6;

include "circomlib/circuits/poseidon.circom";

template Hash() {
    signal input in;
    signal output out;

    component h = Poseidon(1);
    h.inputs[0] <== in;
    out <== h.out;
}

component main {public [in]} = Hash();

/* INPUT = {
    "in": "9"
} */
