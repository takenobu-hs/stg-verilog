

`include "sp1_common.h"

module sp1_ff(
  rst,
  clk,
  en,
  d,
  q
);

  parameter DW = 32;

  input             rst;
  input             clk;
  input             en;
  input   [DW-1:0]  d;
  output  [DW-1:0]  q;

  reg     [DW-1:0]  q;

  always @(posedge clk) begin
    q <= rst ? {DW{1'b0}} : (en ? d : q);
  end

endmodule
