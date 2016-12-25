/* -----------------------------------------------------------------------------
 *
 * FF
 *
 * Note: This is behavior model.
 *       Replace to your target technology cell if you need.
 * -------------------------------------------------------------------------- */


`include "sp1_common.h"


/* ff with write enable */
module sp1_ff(
  rst,
  clk,
  en,
  d,
  q
);

  parameter DW = 32;            // data bit width

  input             rst;        // reset (1:reset / 0:normal)
  input             clk;        // clock
  input             en;         // write enable
  input   [DW-1:0]  d;          // input data
  output  [DW-1:0]  q;          // output data

  reg     [DW-1:0]  q;

  always @(posedge clk) begin
    q <= rst ? {DW{1'b0}} : (en ? d : q);
  end

endmodule
