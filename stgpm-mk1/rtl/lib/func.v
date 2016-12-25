/* -----------------------------------------------------------------------------
 *
 * Functional logics
 *  - multiplexer
 *  - bit decoder
 *
 * -------------------------------------------------------------------------- */


`include "sp1_common.h"


/* -----------------------------------------------------------------------------
 * mux with decoded one-hot select signal
 * -------------------------------------------------------------------------- */

/* 2-to-1 mux */
module sp1_muxd2(
  a0,
  a1,
  s,
  y
);

  parameter DW = 32;            // data bit width

  input   [DW-1:0]  a0;         // input data
  input   [DW-1:0]  a1;         // input data
  input   [1:0]     s;          // one-hot selecter
  output  [DW-1:0]  y;          // output data

  assign y = ({DW{s[0]}} & a0) |
             ({DW{s[1]}} & a1);

endmodule


/* 3-to-1 mux */
module sp1_muxd3(
  a0,
  a1,
  a2,
  s,
  y
);

  parameter DW = 32;            // data bit width

  input   [DW-1:0]  a0;         // input data
  input   [DW-1:0]  a1;         // input data
  input   [DW-1:0]  a2;         // input data
  input   [2:0]     s;          // one-hot selecter
  output  [DW-1:0]  y;          // output data

  assign y = ({DW{s[0]}} & a0) |
             ({DW{s[1]}} & a1) |
             ({DW{s[2]}} & a2);

endmodule


/* 4-to-1 mux */
module sp1_muxd4(
  a0,
  a1,
  a2,
  a3,
  s,
  y
);

  parameter DW = 32;            // data bit width

  input   [DW-1:0]  a0;         // input data
  input   [DW-1:0]  a1;         // input data
  input   [DW-1:0]  a2;         // input data
  input   [DW-1:0]  a3;         // input data
  input   [3:0]     s;          // one-hot selecter
  output  [DW-1:0]  y;          // output data

  assign y = ({DW{s[0]}} & a0) |
             ({DW{s[1]}} & a1) |
             ({DW{s[2]}} & a2) |
             ({DW{s[3]}} & a3);

endmodule


/* 8-to-1 mux */
module sp1_muxd8(
  a0,
  a1,
  a2,
  a3,
  a4,
  a5,
  a6,
  a7,
  s,
  y
);

  parameter DW = 32;            // data bit width

  input   [DW-1:0]  a0;         // input data
  input   [DW-1:0]  a1;         // input data
  input   [DW-1:0]  a2;         // input data
  input   [DW-1:0]  a3;         // input data
  input   [DW-1:0]  a4;         // input data
  input   [DW-1:0]  a5;         // input data
  input   [DW-1:0]  a6;         // input data
  input   [DW-1:0]  a7;         // input data
  input   [7:0]     s;          // one-hot selecter
  output  [DW-1:0]  y;          // output data

  assign y = ({DW{s[0]}} & a0) |
             ({DW{s[1]}} & a1) |
             ({DW{s[2]}} & a2) |
             ({DW{s[3]}} & a3) |
             ({DW{s[4]}} & a4) |
             ({DW{s[5]}} & a5) |
             ({DW{s[6]}} & a6) |
             ({DW{s[7]}} & a7);

endmodule



/* -----------------------------------------------------------------------------
 * mux with encoded priority select signal
 * -------------------------------------------------------------------------- */

/* 2-to-1 mux */
module sp1_mux2(
  a0,
  a1,
  s,
  y
);

  parameter DW = 32;            // data bit width

  input   [DW-1:0]  a0;         // input data
  input   [DW-1:0]  a1;         // input data
  input             s;          // one-hot selecter
  output  [DW-1:0]  y;          // output data

  wire    [1:0]     sd;

  assign sd = s ? 2'b10 : 2'b01;
  sp1_muxd2 #(DW) muxd2 (.a0(a0), .a1(a1), .s(sd), .y(y));

endmodule


/* 3-to-1 mux */
module sp1_mux3(
  a0,
  a1,
  a2,
  s,
  y
);

  parameter DW = 32;            // data bit width

  input   [DW-1:0]  a0;         // input data
  input   [DW-1:0]  a1;         // input data
  input   [DW-1:0]  a2;         // input data
  input   [1:0]     s;          // one-hot selecter
  output  [DW-1:0]  y;          // output data

  wire    [2:0]     sd;

  assign sd = (s == 2'b00) ? 3'b001 :
              (s == 2'b01) ? 3'b010 :
              (s == 2'b10) ? 3'b100 : 3'bxxx;
  sp1_muxd3 #(DW) muxd3 (.a0(a0), .a1(a1), .a2(a2), .s(sd), .y(y));

endmodule


/* 4-to-1 mux */
module sp1_mux4(
  a0,
  a1,
  a2,
  a3,
  s,
  y
);

  parameter DW = 32;            // data bit width

  input   [DW-1:0]  a0;         // input data
  input   [DW-1:0]  a1;         // input data
  input   [DW-1:0]  a2;         // input data
  input   [DW-1:0]  a3;         // input data
  input   [1:0]     s;          // one-hot selecter
  output  [DW-1:0]  y;          // output data

  wire    [3:0]     sd;

  sp1_dec2to4 dec2to4 (.e(s), .d(sd));
  sp1_muxd4 #(DW) muxd4 (.a0(a0), .a1(a1), .a2(a2), .a3(a3), .s(sd), .y(y));

endmodule


/* 8-to-1 mux */
module sp1_mux8(
  a0,
  a1,
  a2,
  a3,
  a4,
  a5,
  a6,
  a7,
  s,
  y
);

  parameter DW = 32;            // data bit width

  input   [DW-1:0]  a0;         // input data
  input   [DW-1:0]  a1;         // input data
  input   [DW-1:0]  a2;         // input data
  input   [DW-1:0]  a3;         // input data
  input   [DW-1:0]  a4;         // input data
  input   [DW-1:0]  a5;         // input data
  input   [DW-1:0]  a6;         // input data
  input   [DW-1:0]  a7;         // input data
  input   [2:0]     s;          // one-hot selecter
  output  [DW-1:0]  y;          // output data

  wire    [7:0]     sd;

  sp1_dec3to8 dec3to8 (.e(s), .d(sd));
  sp1_muxd8 #(DW) muxd8 (.a0(a0), .a1(a1), .a2(a2), .a3(a3),
                         .a4(a4), .a5(a5), .a6(a6), .a7(a7),
                         .s(sd), .y(y));

endmodule



/* -----------------------------------------------------------------------------
 * one-hot decoder
 * -------------------------------------------------------------------------- */

/* 2-to-4 decoder */
module sp1_dec2to4(
  e,
  d,
);

  input   [1:0]     e;		// encoded input data
  output  [3:0]     d;          // decoded output data

  assign d = (e == 2'd0) ? 4'b0001 :
             (e == 2'd1) ? 4'b0010 :
             (e == 2'd2) ? 4'b0100 :
             (e == 2'd3) ? 4'b1000 : 4'bxxxx;

endmodule


/* 3-to-8 decoder */
module sp1_dec3to8(
  e,
  d,
);

  input   [2:0]     e;		// encoded input data
  output  [7:0]     d;		// decoded output data

  assign d = (e == 3'd0) ? 8'b00000001 :
             (e == 3'd1) ? 8'b00000010 :
             (e == 3'd2) ? 8'b00000100 :
             (e == 3'd3) ? 8'b00001000 :
             (e == 3'd4) ? 8'b00010000 :
             (e == 3'd5) ? 8'b00100000 :
             (e == 3'd6) ? 8'b01000000 :
             (e == 3'd7) ? 8'b10000000 : 8'bxxxxxxxx;

endmodule


