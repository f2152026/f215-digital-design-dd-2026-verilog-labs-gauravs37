// cla64_hier.v
// BONUS -- open-ended. No detailed scaffold is provided; this is meant to
// be a genuine design exercise. Not required for lab submission.
//
// You will likely need to modify cla4.v (or add signals alongside it) so
// that block-generate/block-propagate summaries of its own Gi, Pi signals
// are exposed as outputs, since the second-level lookahead unit below
// needs them. As with every module in this lab from Task 2 onward, every
// gate/assign you add should carry an explicit delay.
//
// Starting point (from Tutorial 3, Q4(d)):
//   - Reuse 16 four-bit CLA blocks (your cla4.v) -- their internal logic
//     doesn't change.
//   - For each block k, define:
//       Gblk_k = "this block produces a carry regardless of its incoming
//                 carry" -- a Boolean function of that block's own 4
//                 bit-level Gi, Pi signals.
//       Pblk_k = "an incoming carry sails straight through this whole
//                 block" -- likewise a function of its own Gi, Pi.
//   - Build a second-level lookahead unit -- structurally identical to
//     cla4.v, just one level up -- that computes each block's carry-in
//     directly from Gblk_0..Gblk_15, Pblk_0..Pblk_15, and cin, instead of
//     rippling block to block.
//
// To test this, wire it into dut.v as a fourth option (copy the pattern
// used for the other three) and run it through the same tb.v. Compare
// your final delay to cla64_blocked.v from Task 4.

module cla64_hier(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);

  wire [15:0] P_blk, G_blk;
  wire [16:0] c;
  assign c[0] = cin;

  // Level-1: 16 4-bit CLA blocks
  genvar i;
  generate
    for (i = 0; i < 16; i = i + 1) begin : gen_level1_blocks
      cla4 U_CLA4 (
        .a     (a[4*i + 3 : 4*i]),
        .b     (b[4*i + 3 : 4*i]),
        .cin   (c[i]),
        .sum   (sum[4*i + 3 : 4*i]),
        .cout  (), // Driven globally by Level-2 lookahead
        .P_blk (P_blk[i]),
        .G_blk (G_blk[i])
      );
    end
  endgenerate

  // Level-2: Lookahead carry generator across the 16 blocks
  generate
    for (i = 0; i < 16; i = i + 1) begin : gen_level2_carries
      assign #(2) c[i+1] = G_blk[i] | (P_blk[i] & c[i]);
    end
  endgenerate

  assign cout = c[16];

endmodule