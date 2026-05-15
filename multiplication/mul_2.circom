pragma circom 2.1.6;

// MULTIPLICATION CIRCUIT (2)
// Prove that you know a such that a * b = c
// without revealing a.
//
// Private input: a (the first factor)
// Public inputs:  b (the second factor), c (the product)

template Multiply2() {
    // --- signals ---
    signal input a;   // private
    signal input b;   // public
    signal output c;  // public

    // --- constraints ---
    // <== assigns and constrains in one step
    c <== a * b;
}

component main {public [b]} = Multiply2();

/* INPUT = {
    "a": "5",
    "b": "6"
} */