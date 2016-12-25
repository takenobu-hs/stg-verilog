/* -----------------------------------------------------------------------------
 *
 * RAM
 *
 * -------------------------------------------------------------------------- */


`include "sp1_common.h"


module sp1_ram(
  rst,
  clk,
  cs,
  we,
  adrs,
  din,
  dout
);

  parameter AW = 6;             // address bit width
  parameter DW = 32;            // data bit width
  parameter DS = 1<<AW;         // data row size

  input             rst;        // reset (unuse)
  input             clk;        // clock
  input             cs;         // chip select (1:access / 0:hold)
  input             we;         // write enable (1:write / 0:read)
  input   [AW-1:0]  adrs;       // address
  input   [DW-1:0]  din;        // write data
  output  [DW-1:0]  dout;       // read data

  reg     [DW-1:0]  mem [0:DS-1];
  reg     [DW-1:0]  dout;

  /* memory model */
  always @(posedge clk) begin
    if (cs & we) begin
      mem[adrs] <= din;
      dout <= {DW{1'bx}};
    end
    else if (cs & ~we) begin
      dout <= mem[adrs];
    end
    else begin
      mem[adrs] <= {DW{1'bx}};
      dout <= {DW{1'bx}};
    end
  end


`ifndef SYNTH
  /* unknown detection */
  wire det = we ? ^{adrs, din} : ^adrs;
  always @(posedge clk) begin
    if (cs == 1'b1 && det === 1'bx) begin
      $display("Warning: %d: %m: unknown %b %b %h %h",
               $time, cs, we, adrs, din);
    end
  end
`endif

endmodule
