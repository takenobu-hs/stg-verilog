

`include "sp1_common.h"

module top();

  parameter HIGH = 1'b1;
  parameter LOW  = 1'b0;
  parameter UNK  = 1'bx;

  reg               rst;
  reg               clk;


  /* include test vector */
`include "pattern.v"


`ifdef SP1_MUXD
  reg     [DW-1:0]  a0;
  reg     [DW-1:0]  a1;
  reg     [DW-1:0]  a2;
  reg     [DW-1:0]  a3;
  reg     [DW-1:0]  a4;
  reg     [DW-1:0]  a5;
  reg     [DW-1:0]  a6;
  reg     [DW-1:0]  a7;
  reg     [7:0]     s;
  wire    [DW-1:0]  muxd2_y;
  wire    [DW-1:0]  muxd3_y;
  wire    [DW-1:0]  muxd4_y;
  wire    [DW-1:0]  muxd8_y;
 
  /* dut */
  sp1_muxd2 #(DW) sp1_muxd2(.a0(a0), .a1(a1),
                            .s(s[1:0]), .y(muxd2_y));
  sp1_muxd3 #(DW) sp1_muxd3(.a0(a0), .a1(a1), .a2(a2),
                            .s(s[2:0]), .y(muxd3_y));
  sp1_muxd4 #(DW) sp1_muxd4(.a0(a0), .a1(a1), .a2(a2), .a3(a3),
                            .s(s[3:0]), .y(muxd4_y));
  sp1_muxd8 #(DW) sp1_muxd8(.a0(a0), .a1(a1), .a2(a2), .a3(a3),
                            .a4(a4), .a5(a5), .a6(a6), .a7(a7),
                            .s(s[7:0]), .y(muxd8_y));

  /* monitor */
  initial begin
    $monitor("monitor   : %7d: %h %h %h %h  %h %h %h %h  %h  %h %h %h %h",
             $time, a0, a1, a2, a3, a4, a5, a6, a7, s,
             muxd2_y, muxd3_y, muxd4_y, muxd8_y);
  end
`endif // SP1_MUXD



`ifdef SP1_MUX
  reg     [DW-1:0]  a0;
  reg     [DW-1:0]  a1;
  reg     [DW-1:0]  a2;
  reg     [DW-1:0]  a3;
  reg     [DW-1:0]  a4;
  reg     [DW-1:0]  a5;
  reg     [DW-1:0]  a6;
  reg     [DW-1:0]  a7;
  reg     [7:0]     s;
  wire    [DW-1:0]  mux2_y;
  wire    [DW-1:0]  mux3_y;
  wire    [DW-1:0]  mux4_y;
  wire    [DW-1:0]  mux8_y;
 
  /* dut of mux */
  sp1_mux2 #(DW) sp1_mux2(.a0(a0), .a1(a1),
                          .s(s[0]), .y(mux2_y));
  sp1_mux3 #(DW) sp1_mux3(.a0(a0), .a1(a1), .a2(a2),
                          .s(s[1:0]), .y(mux3_y));
  sp1_mux4 #(DW) sp1_mux4(.a0(a0), .a1(a1), .a2(a2), .a3(a3),
                          .s(s[1:0]), .y(mux4_y));
  sp1_mux8 #(DW) sp1_mux8(.a0(a0), .a1(a1), .a2(a2), .a3(a3),
                          .a4(a4), .a5(a5), .a6(a6), .a7(a7),
                          .s(s[2:0]), .y(mux8_y));

  /* monitor */
  initial begin
    $monitor("monitor   : %7d: %h %h %h %h  %h %h %h %h  %h  %h %h %h %h",
             $time, a0, a1, a2, a3, a4, a5, a6, a7, s,
             mux2_y, mux3_y, mux4_y, mux8_y);
  end
`endif // SP1_MUX



`ifdef SP1_DEC
  /* for dec test */
  reg     [2:0]     e;
  wire    [3:0]     dec2_4_d;
  wire    [7:0]     dec3_8_d;

  /* dut */
  sp1_dec2to4 dec2to4(.e(e[1:0]), .d(dec2_4_d));
  sp1_dec3to8 dec3to8(.e(e), .d(dec3_8_d));

  /* monitor */
  initial begin
    $monitor("monitor   : %7d: %h  %h %h",
             $time, e, dec2_4_d, dec3_8_d);
  end
`endif // SP1_DEC


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
      $finish;
    end
  endtask


endmodule
