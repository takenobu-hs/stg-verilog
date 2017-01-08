/* -----------------------------------------------------------------------------
 *
 * heap memory cell
 *
 *   - dual word accessible heap memory
 *   - unaligned dual addressing
 *
 * -------------------------------------------------------------------------- */


`include "sp1_common.h"


/* dual word heap memory */
module sp1_hmem_dualram(
  rst,
  clk,
  cs_ev,
  cs_od,
  we_ev,
  we_od,
  adrs_ev,
  adrs_od,
  wr_dt_ev,
  wr_dt_od,
  rd_dt_ev,
  rd_dt_od
);

  parameter DW = `SP1_WORD_WIDTH;               // data width
  parameter HEAP_ABITS = `SP1_HEAP_ABITS;       // bit position of heap address
  parameter WORD_ABITS = `SP1_WORD_ABITS;       // bit position of word address
  parameter AW = (HEAP_ABITS - WORD_ABITS) - 1; // address width for heap cell

  input             rst;        // reset (unuse in this model)
  input             clk;        // clock
  input             cs_ev;      // chip select for even
  input             cs_od;      // chip select for odd
  input             we_ev;      // write enable for even
  input             we_od;      // write enable for even
  input   [DW-1:0]  adrs_ev;    // address for even
  input   [DW-1:0]  adrs_od;    // address for odd
  input   [DW-1:0]  wr_dt_ev;   // write data for even
  input   [DW-1:0]  wr_dt_od;   // write data for odd
  output  [DW-1:0]  rd_dt_ev;   // read data for even
  output  [DW-1:0]  rd_dt_od;   // read data for odd

  wire    [AW-1:0]  hm_adrs_ev; // address for even memory cell
  wire    [AW-1:0]  hm_adrs_od; // address for odd memory cell
  

  /* twist address */
  assign hm_adrs_ev = adrs_ev[HEAP_ABITS-1:WORD_ABITS+1];
  assign hm_adrs_od = adrs_od[HEAP_ABITS-1:WORD_ABITS+1];


  /* memory cell */
  sp1_ram #(AW, DW) mem_ev(
    .rst(rst),
    .clk(clk),
    .cs(cs_ev),
    .we(we_ev),
    .adrs(hm_adrs_ev),
    .din(wr_dt_ev),
    .dout(rd_dt_ev)
  );

  sp1_ram #(AW, DW) mem_od(
    .rst(rst),
    .clk(clk),
    .cs(cs_od),
    .we(we_od),
    .adrs(hm_adrs_od),
    .din(wr_dt_od),
    .dout(rd_dt_od)
  );

endmodule
