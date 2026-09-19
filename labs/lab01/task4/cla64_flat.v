// cla64_flat.v
// A flat, unblocked 64-bit carry-lookahead adder: every carry is computed
// directly (two-level, no rippling), exactly like cla4.v, just scaled to
// 64 bits. Add delays throughout (same convention as cla4.v) so it can be
// fairly compared against rca64.v and cla64_blocked.v.

module cla64_flat(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);

  wire [63:0] p, g;
  wire [64:1] c;

  genvar i, j;
  generate
    for (i = 0; i < 64; i = i + 1) begin : gen_pg
      xor #(2) (p[i], a[i], b[i]);
      and #(2) (g[i], a[i], b[i]);
    end
  endgenerate

  // Direct flat carry generation: C_k = G_{k-1} + P_{k-1}G_{k-2} + ... + (P_{k-1}..P_0)Cin
  generate
    for (i = 1; i <= 64; i = i + 1) begin : gen_carry
      wire [i:0] terms;
      
      // Last term: (P_{i-1} & ... & P_0) & cin
      assign terms[0] = (&p[i-1:0]) & cin;
      
      // Intermediate product terms: (P_{i-1} & ... & P_{j+1}) & g[j]
      for (j = 0; j < i - 1; j = j + 1) begin : gen_mid_terms
        assign terms[j+1] = (&p[i-1:j+1]) & g[j];
      end
      
      // First term: g[i-1]
      assign terms[i] = g[i-1];
      
      assign #(2) c[i] = |terms;
    end
  endgenerate

  assign cout = c[64];
  assign #(2) sum = p ^ {c[63:1], cin};

endmodule