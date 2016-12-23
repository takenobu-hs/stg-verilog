

`include "sp1_common.h"

module sp1_ram(
  rst,
  clk,
  cs,
  we,
  adr,
  din,
  dout
);

  parameter AW = 6;
  parameter DW = 32;
  parameter DS = 1<<AW;

  input             rst;
  input             clk;
  input             cs;
  input             we;
  input   [AW-1:0]  adr;
  input   [DW-1:0]  din;
  output  [DW-1:0]  dout;

  reg     [DW-1:0]  mem [0:DS-1];
  reg     [DW-1:0]  dout;

  always @(posedge clk) begin
    if (cs & we) begin
      mem[adr] <= din;
      dout <= {DW{1'bx}};
    end
    else if (cs & ~we) begin
      dout <= mem[adr];
    end
    else begin
      mem[adr] <= {DW{1'bx}};
      dout <= {DW{1'bx}};
    end
  end


`ifndef SYNTH
  /* unknown detection */
  wire det = we ? ^{adr, din} : ^adr;
  always @(posedge clk) begin
    if (cs == 1'b1 && det === 1'bx) begin
      $display("Warning: %d: %m: unknown %b %b %h %h", $time, cs, we, adr, din);
    end
  end
`endif

endmodule
