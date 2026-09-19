module tb;

  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;
  integer    i, j;
  integer    errors;

  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
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
    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i;
        t_b = j;
        #5;
        // exactly one of GT, LT, EQ must be 1
        if (t_gt + t_lt + t_eq != 1) begin
          errors = errors + 1;
          $display("MISMATCH at t=%0t: A=%0d B=%0d GT=%b LT=%b EQ=%b (sum=%0d, expected exactly one hot)",
                    $time, t_a, t_b, t_gt, t_lt, t_eq, t_gt + t_lt + t_eq);
        end
      end
    end

    if (errors == 0)
      $display("PASS: all 16 combinations self-consistent.");
    else
      $display("FAIL: %0d combination(s) violated the exactly-one-hot property.", errors);

    $finish;
  end

  initial
    $monitor($time, " A=%0d B=%0d | GT=%b LT=%b EQ=%b", t_a, t_b, t_gt, t_lt, t_eq);

endmodule