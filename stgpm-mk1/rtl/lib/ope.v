/* -----------------------------------------------------------------------------
 *
 * Operational logics
 *  - adder/subtractor
 *  - incrementer/decrementer
 *  - comparator
 *
 * Note: This is non-optimized logic.
 *       Replace to your logic if you need to optimize.
 * -------------------------------------------------------------------------- */


`include "sp1_common.h"


/* -----------------------------------------------------------------------------
 * adder/subtractor
 * -------------------------------------------------------------------------- */

/* adder */
module sp1_adder(
  a0,
  a1,
  y,
  c
);

  parameter DW = 32;            // data bit width

  input   [DW-1:0]  a0;         // input operand 0
  input   [DW-1:0]  a1;         // input operand 1
  output  [DW-1:0]  y;          // added data
  output            c;          // carry bit

  assign {c, y} = a0 + a1;

endmodule



/* subtractor */
module sp1_sub(
  a0,
  a1,
  y,
  b
);

  parameter DW = 32;            // data bit width

  input   [DW-1:0]  a0;         // input operand 0
  input   [DW-1:0]  a1;         // input operand 1
  output  [DW-1:0]  y;          // subtranted data
  output            b;          // borrow bit

  assign {b, y} = a0 - a1;

endmodule



/* ----------------------------------------------------------------------------- * incrementer/decrementer
 * -------------------------------------------------------------------------- */

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



/* ----------------------------------------------------------------------------- * comparator
 * -------------------------------------------------------------------------- */

/* equal comparator */
module sp1_comp_eq(
  a0,
  a1,
  eq
);

  parameter DW = 32;            // data bit width

  input   [DW-1:0]  a0;         // input operand 0
  input   [DW-1:0]  a1;         // input operand 1
  output            eq;         // compare result (1:a0==a1 / 0:not a0==a1)

  assign eq = (a0 == a1);

endmodule



/* greater-than comparator */
module sp1_comp_gt(
  a0,
  a1,
  gt
);

  parameter DW = 32;            // data bit width

  input   [DW-1:0]  a0;         // input operand 0
  input   [DW-1:0]  a1;         // input operand 1
  output            gt;         // compare result (1:a0>a1 / 0:a0<=a1)

  assign gt = (a0 > a1);

endmodule



