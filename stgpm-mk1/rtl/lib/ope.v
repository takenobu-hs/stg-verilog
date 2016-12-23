

`include "sp1_common.h"


module sp1_adder(
  a,
  b,
  y,
  c
);

  parameter DW = 32;

  input   [DW-1:0]  a;
  input   [DW-1:0]  b;
  output  [DW-1:0]  y;
  output            c;    // carry

  assign {c, y} = a + b;

endmodule



module sp1_incr(
  a,
  y,
  c
);

  parameter DW = 32;

  input   [DW-1:0]  a;
  output  [DW-1:0]  y;
  output            c;    // carry

  assign {c, y} = a + 1;

endmodule



module sp1_decr(
  a,
  y,
  b
);

  parameter DW = 32;

  input   [DW-1:0]  a;
  output  [DW-1:0]  y;
  output            b;    // carry

  assign {b, y} = a - 1;

endmodule

