/* -----------------------------------------------------------------------------
 *
 * Operational logics
 *  - adder
 *  - incrementer/decrementer
 *  - comparator
 *
 * Note: This is non-optimized logic.
 *       Replace to your logic if you need to optimize.
 * -------------------------------------------------------------------------- */


`include "sp1_common.h"


/* -----------------------------------------------------------------------------
 * adder
 * -------------------------------------------------------------------------- */

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
  a,
  b,
  eq
);

  parameter DW = 32;            // data bit width

  input   [DW-1:0]  a;          // input operand a
  input   [DW-1:0]  b;          // input operand b
  output            eq;         // compare result (1:a==b / 0:not a==b)

  assign eq = (a == b);

endmodule



/* greater-than comparator */
module sp1_comp_gt(
  a,
  b,
  gt
);

  parameter DW = 32;            // data bit width

  input   [DW-1:0]  a;          // input operand a
  input   [DW-1:0]  b;          // input operand b
  output            gt;         // compare result (1:a>b / 0:a<=b)

  assign gt = (a > b);

endmodule



