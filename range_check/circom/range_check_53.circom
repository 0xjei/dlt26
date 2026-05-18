pragma circom 2.1.6;

include "circomlib/circuits/bitify.circom";

// RANGE CHECK 53 bits
// Prove that a secret value lies in [0, 2^53) without revealing it.
//
// Private input: value

template RangeCheck(n) {
    signal input value;

    component bits = Num2Bits(n);
    bits.in <== value;
}

component main = RangeCheck(53);

/* INPUT = {
    "value": "42"
} */
