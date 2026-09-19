module tb;

  reg  [$clog2(4)-1:0] t_sel;
  wire [7:0]            t_dout;

  lut #(.WIDTH(8), .DEPTH(4)) DUT (
    .sel  (t_sel),
    .dout (t_dout)
  );

  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    t_sel = 0; #5;
    t_sel = 1; #5;
    t_sel = 2; #5;
    t_sel = 3; #5;
    $finish;
  end

  initial
    $monitor($time, " sel=%0d | dout=%0d", t_sel, t_dout);

endmodule