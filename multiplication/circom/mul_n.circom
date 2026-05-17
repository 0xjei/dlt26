pragma circom 2.1.6;

// MULTIPLICATION CIRCUIT (N)
// Prove that you know in[0..N-1] such that in[0] * in[1] * ... * in[N-1] = out
// without revealing any of the inputs.
//
// Private inputs: in[0..N-1] (all factors)
// Public output:  out (the product)

template MultiplyN(N) {
    // --- signals ---
    signal input in[N];   // all private
    signal output out;    // public

    // --- accumulator ---
    // same idea as Multiply3 but generalised to N inputs
    // each step multiplies the running product by the next input
    signal acc[N];
    acc[0] <== in[0];

    for (var i = 1; i < N; i++) {
        acc[i] <== acc[i-1] * in[i];
    }

    out <== acc[N-1];
}

component main = MultiplyN(5);

/* INPUT = {
    "in": ["5", "6", "7", "2", "6"]
} */