pragma circom 2.1.6;

// MULTIPLICATION CIRCUIT (3)
// Prove that you know a and b such that a * b * c = out
// without revealing a and b.
//
// Private inputs: a, b (the secret factors)
// Public inputs:  c (the third factor), out (the product)

template Multiply3() {
    // --- signals ---
    signal input a;    // private
    signal input b;    // private
    signal input c;    // public
    signal output out; // public

    // --- intermediate signal ---
    // circom is quadratic max per constraint
    // you cannot do a * b * c in one step
    // you need to split it into two multiplications
    signal ab;
    ab <== a * b;
    out <== ab * c;
}

component main {public [c]} = Multiply3();

/* INPUT = {
    "a": "5",
    "b": "6",
    "c": "7"
} */