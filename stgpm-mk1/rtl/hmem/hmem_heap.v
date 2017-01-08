/* -----------------------------------------------------------------------------
 *
 * heam memory
 *
 * -------------------------------------------------------------------------- */


`include "sp1_common.h"


/* dual word accessible heap memory */
module sp1_hmem_heap(
  rst,
  clk,
  h5_hmem_acs_en,
  h5_hmem_acs_type,
  h5_hmem_acs_sz,
  h5_hmem_acs_adrs,
  h5_hmem_wr_dt0,
  h5_hmem_wr_dt1,
  h6_hmem_rd_dt0,
  h6_hmem_rd_dt1
);

  parameter DW = `SP1_WORD_WIDTH;               // data width
  parameter HEAP_ABITS = `SP1_HEAP_ABITS;       // bit position of heap address
  parameter WORD_ABITS = `SP1_WORD_ABITS;       // bit position of word address

  input             rst;                // reset (1:reset / 0:normal)
  input             clk;                // clock
  input             h5_hmem_acs_en;     // access enabele (1:enable / 0:none)
  input             h5_hmem_acs_type;   // access type (1:write / 0:read)
  input             h5_hmem_acs_sz;     // access size (1:double / 0:single)
  input   [DW-1:0]  h5_hmem_acs_adrs;   // access address of #0
  input   [DW-1:0]  h5_hmem_wr_dt0;     // write data of #0
  input   [DW-1:0]  h5_hmem_wr_dt1;     // write data of #1
  output  [DW-1:0]  h6_hmem_rd_dt0;     // read data of #0
  output  [DW-1:0]  h6_hmem_rd_dt1;     // read data of #1

  wire    [DW-1:0]  h5_hmem_acs_adrs0;
  wire    [DW-1:0]  h5_hmem_acs_adrs1;
  wire              h5_hmem_adrs_eo_bit;
  wire              h5_hmem_acs_ev_sel;
  wire              h5_hmem_acs_od_sel;
  wire              h5_hmem_acs_rd0_sel;
  wire              h5_hmem_acs_rd1_sel;
  
  wire              h5_hmem_cs_ev;
  wire              h5_hmem_cs_od;
  wire              h5_hmem_we_ev;
  wire              h5_hmem_we_od;
  wire    [DW-1:0]  h5_hmem_adrs_ev;
  wire    [DW-1:0]  h5_hmem_adrs_od;
  wire    [DW-1:0]  h5_hmem_wr_dt_ev;
  wire    [DW-1:0]  h5_hmem_wr_dt_od;
  wire    [DW-1:0]  h6_hmem_rd_dt_ev;
  wire    [DW-1:0]  h6_hmem_rd_dt_od;
  wire              h6_hmem_acs_rd0_sel;
  wire              h6_hmem_acs_rd1_sel;

  parameter HIGH = 1'b1;
  parameter LOW  = 1'b0;
  parameter UNK  = 1'bx;

  parameter SIZE_SINGLE = 1'b0;
  parameter SIZE_DOUBLE = 1'b1;
  parameter TYPE_WT = 1'b1;
  parameter TYPE_RD = 1'b0;
  parameter EVEN = 1'b0;
  parameter ODD  = 1'b1;


/* -----------------------------------------------------------------------------
 * stage <5>
 * -------------------------------------------------------------------------- */

  /* memory access control */
  assign h5_hmem_adrs_eo_bit = h5_hmem_acs_adrs[WORD_ABITS];
  assign h5_hmem_cs_ev = h5_hmem_acs_en &&
                         ((h5_hmem_adrs_eo_bit == EVEN) ||
                          ((h5_hmem_adrs_eo_bit == ODD) &&
                            (h5_hmem_acs_sz == SIZE_DOUBLE)));
  assign h5_hmem_cs_od = h5_hmem_acs_en &&
                         ((h5_hmem_adrs_eo_bit == ODD) ||
                          ((h5_hmem_adrs_eo_bit == EVEN) &&
                            (h5_hmem_acs_sz == SIZE_DOUBLE)));
  assign h5_hmem_we_ev = (h5_hmem_acs_type == TYPE_WT);
  assign h5_hmem_we_od = h5_hmem_we_ev;

  /* data flow control */
  assign h5_hmem_acs_ev_sel = !(h5_hmem_adrs_eo_bit == EVEN);
  assign h5_hmem_acs_od_sel = !h5_hmem_acs_ev_sel;
  assign h5_hmem_acs_rd0_sel = !(h5_hmem_adrs_eo_bit == EVEN);
  assign h5_hmem_acs_rd1_sel = !h5_hmem_acs_rd0_sel;

  /* address generation */
  assign h5_hmem_acs_adrs0 = h5_hmem_acs_adrs;
  assign h5_hmem_acs_adrs1 = h5_hmem_acs_adrs + (1<<WORD_ABITS);

  /* access mux */
  assign h5_hmem_adrs_ev = h5_hmem_acs_ev_sel ? h5_hmem_acs_adrs1 :
                                                h5_hmem_acs_adrs0;
  assign h5_hmem_adrs_od = h5_hmem_acs_od_sel ? h5_hmem_acs_adrs1 :
                                                h5_hmem_acs_adrs0;
  assign h5_hmem_wr_dt_ev = h5_hmem_acs_ev_sel ? h5_hmem_wr_dt1 :
                                                 h5_hmem_wr_dt0;
  assign h5_hmem_wr_dt_od = h5_hmem_acs_od_sel ? h5_hmem_wr_dt1 :
                                                 h5_hmem_wr_dt0;


/* -----------------------------------------------------------------------------
 * stage <6>
 * -------------------------------------------------------------------------- */

  always @(posedge clk) begin
//`define __TMP__
`ifdef __TMP__
    if (HIGH) begin
      $display("hmem_heap1: %7d: %b  (eosel:%b %b) (rdsel:%b %b)  %h %h  %h %h",
               $time, h5_hmem_adrs_eo_bit,
               h5_hmem_acs_ev_sel,
               h5_hmem_acs_od_sel,
               h5_hmem_acs_rd0_sel,
               h5_hmem_acs_rd1_sel,
               h5_hmem_acs_adrs0,
               h5_hmem_acs_adrs1,
               h5_hmem_wr_dt0,
               h5_hmem_wr_dt1);
      $display("hmem_heap2: %7d: (cs:%b %b) (we:%b %b)  %h %h  %h %h  %h %h",
               $time,
               h5_hmem_cs_ev,
               h5_hmem_cs_od,
               h5_hmem_we_ev,
               h5_hmem_we_od,
               h5_hmem_adrs_ev,
               h5_hmem_adrs_od,
               h5_hmem_wr_dt_ev,
               h5_hmem_wr_dt_od,
               h6_hmem_rd_dt_ev,
               h6_hmem_rd_dt_od);
    end
`endif // __TMP__
  end

  /* heap memory */
  sp1_hmem_dualram hmem_dualram(
    .rst(rst),
    .clk(clk),
    .cs_ev(h5_hmem_cs_ev),
    .cs_od(h5_hmem_cs_od),
    .we_ev(h5_hmem_we_ev),
    .we_od(h5_hmem_we_od),
    .adrs_ev(h5_hmem_adrs_ev),
    .adrs_od(h5_hmem_adrs_od),
    .wr_dt_ev(h5_hmem_wr_dt_ev),
    .wr_dt_od(h5_hmem_wr_dt_od),
    .rd_dt_ev(h6_hmem_rd_dt_ev),
    .rd_dt_od(h6_hmem_rd_dt_od)
  );

  /* output mux */
  sp1_ff #(2) h6_rd_sel(.rst(rst), .clk(clk), .en(HIGH),
                        .d({h5_hmem_acs_rd1_sel, h5_hmem_acs_rd0_sel}),
                        .q({h6_hmem_acs_rd1_sel, h6_hmem_acs_rd0_sel}));
  assign h6_hmem_rd_dt0 = h6_hmem_acs_rd0_sel ? h6_hmem_rd_dt_od :
                                                h6_hmem_rd_dt_ev;
  assign h6_hmem_rd_dt1 = h6_hmem_acs_rd1_sel ? h6_hmem_rd_dt_od :
                                                h6_hmem_rd_dt_ev;

endmodule
