module lut #(
  parameter WIDTH = 8,
  parameter DEPTH = 4
) (
  input      [$clog2(DEPTH)-1:0] sel,
  output reg [WIDTH-1:0]         dout
);

  reg [WIDTH-1:0] mem [0:DEPTH-1];

  integer i;

  // Initialize mem[i] = i*i
  initial begin
    for (i = 0; i < DEPTH; i = i + 1)
      mem[i] = i * i;
  end

  // Combinational read: dout continuously reflects mem[sel]
  always @(*) begin
    dout = mem[sel];
  end

endmodule