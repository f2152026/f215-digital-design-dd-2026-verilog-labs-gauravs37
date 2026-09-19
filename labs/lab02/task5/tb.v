module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;
  integer    i, j, k;
  integer    errors;
  reg  [3:0] expected;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        for (k = 0; k < 2; k = k + 1) begin
          t_a  = i;
          t_b  = j;
          t_op = k;
          #5;
          expected = (t_op == 0) ? (t_a + t_b) : (t_a - t_b);
          if (t_result !== expected) begin
            errors = errors + 1;
            $display("MISMATCH at t=%0t: a=%0d b=%0d op=%b | result=%0d expected=%0d",
                      $time, t_a, t_b, t_op, t_result, expected);
          end
        end
      end
    end

    if (errors == 0)
      $display("PASS: all 512 combinations correct.");
    else
      $display("FAIL: %0d combination(s) incorrect.", errors);

    $finish;
  end

  initial
    $monitor($time, " a=%0d b=%0d op=%b | result=%0d", t_a, t_b, t_op, t_result);

endmodule