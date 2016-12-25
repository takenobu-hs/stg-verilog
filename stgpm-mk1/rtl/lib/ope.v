/* -----------------------------------------------------------------------------
 *
 * Operational logics
 *  - adder
 *  - incrementer/decrementer
 *
 * -------------------------------------------------------------------------- */


`include "sp1_common.h"


/* adder */
module sp1_adder(
  a,
  b,
  y,
  c
);

  parameter DW = 32;            // data bit width

  input   [DW-1:0]  a;          // input operand a
  input   [DW-1:0]  b;          // input operand b
  output  [DW-1:0]  y;          // added data
  output            c;          // carry bit

  assign {c, y} = a + b;

endmodule



/* incrementer */
module sp1_incr(
  a,
  y,
  c
);

  parameter DW = 32;            // data bit width

  input   [DW-1:0]  a;          // input operand
  output  [DW-1:0]  y;          // incremented data
  output            c;          // carry bit

  assign {c, y} = a + 1;

endmodule



/* decrementer */
module sp1_decr(
  a,
  y,
  b
);

  parameter DW = 32;            // data bit width

  input   [DW-1:0]  a;          // input operand
  output  [DW-1:0]  y;          // decremented data
  output            b;          // borrow bit

  assign {b, y} = a - 1;

endmodule

