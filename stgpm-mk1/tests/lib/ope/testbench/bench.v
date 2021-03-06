

`include "sp1_common.h"

module top();

  parameter HIGH = 1'b1;
  parameter LOW  = 1'b0;
  parameter UNK  = 1'bx;

  reg               rst;
  reg               clk;


  /* include test vector */
`include "pattern.v"


`ifdef SP1_ADDER
  reg     [DW-1:0]  a0;
  reg     [DW-1:0]  a1;
  wire    [DW-1:0]  y;
  wire              c;

  /* dut */
  sp1_adder #(DW) sp1_adder(.a0(a0), .a1(a1), .y(y), .c(c));

  /* monitor */
  initial begin
    $monitor("monitor   : %7d: %h %h  %b %h",
             $time, a0, a1, c, y);
  end
`endif // SP1_ADDER



`ifdef SP1_SUB
  reg     [DW-1:0]  a0;
  reg     [DW-1:0]  a1;
  wire    [DW-1:0]  y;
  wire              b;

  /* dut */
  sp1_sub #(DW) sp1_sub(.a0(a0), .a1(a1), .y(y), .b(b));

  /* monitor */
  initial begin
    $monitor("monitor   : %7d: %h %h  %b %h",
             $time, a0, a1, b, y);
  end
`endif // SP1_SUB



`ifdef SP1_INCR
  reg     [DW-1:0]  a;
  wire    [DW-1:0]  y;
  wire              c;

  /* dut */
  sp1_incr #(DW) sp1_incr(.a(a), .y(y), .c(c));

  /* monitor */
  initial begin
    $monitor("monitor   : %7d: %h  %b %h",
             $time, a, c, y);
  end
`endif // SP1_INCR



`ifdef SP1_DECR
  reg     [DW-1:0]  a;
  wire    [DW-1:0]  y;
  wire              b;

  /* dut */
  sp1_decr #(DW) sp1_decr(.a(a), .y(y), .b(b));

  /* monitor */
  initial begin
    $monitor("monitor   : %7d: %h  %b %h",
             $time, a, b, y);
  end
`endif // SP1_DECR



`ifdef SP1_COMP_EQ
  reg     [DW-1:0]  a0;
  reg     [DW-1:0]  a1;
  wire              eq;

  /* dut */
  sp1_comp_eq #(DW) sp1_comp_eq(.a0(a0), .a1(a1), .eq(eq));

  /* monitor */
  initial begin
    $monitor("monitor   : %7d: %h %h  %b",
             $time, a0, a1, eq);
  end
`endif // SP1_COMP_EQ



`ifdef SP1_COMP_GT
  reg     [DW-1:0]  a0;
  reg     [DW-1:0]  a1;
  wire              gt;

  /* dut */
  sp1_comp_gt #(DW) sp1_comp_gt(.a0(a0), .a1(a1), .gt(gt));

  /* monitor */
  initial begin
    $monitor("monitor   : %7d: %h %h  %b",
             $time, a0, a1, gt);
  end
`endif // SP1_COMP_GT



  /* clock */
  initial begin
    #0 clk = LOW;
    #5;
    forever begin
      #5 clk = ~clk;
    end
  end


  /* initialize pin */
  initial begin
    rst = HIGH;
    repeat(5) @(posedge clk);
    #1 rst = LOW;
  end


  /* cycle */
  integer cycle;
  initial cycle = 0;
  always @(posedge clk) cycle = cycle + 1;


  /* finish */
  initial begin
    #1000 $finish;
  end


  /* dump var */
`ifdef WAVE
  initial begin
    $dumpfile("wave.vcd");
    $dumpvars();
  end
`endif


  /* finish */
  task halt;
    begin
      repeat(5) @(posedge clk);
      $display("halt      : halt");
      $finish;
    end
  endtask


endmodule
