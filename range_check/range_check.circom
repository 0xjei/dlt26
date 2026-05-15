pragma circom 2.1.6;

include "circomlib/circuits/bitify.circom";

// RANGE CHECK CIRCUIT
// Prove that a secret value lies within the interval [0, 2^n)
// without revealing the value.
//
// Private input: value (your secret)
// Public input:  none (the range is fixed by the template parameter n)

template RangeCheck(n) {
    // --- signals ---
    signal input value;  // private

    // --- range check ---
    // Num2Bits decomposes value into n bits
    // if value >= 2^n it will fail to decompose — proof rejected
    // this implicitly proves 0 <= value < 2^n
    component bits = Num2Bits(n);
    bits.in <== value;
}

// proves value fits in 32 bits — 0 <= value < 2^32
component main = RangeCheck(32);

/* INPUT = {
    "value": "42"
} */