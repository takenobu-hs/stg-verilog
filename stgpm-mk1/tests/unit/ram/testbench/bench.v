

`include "sp1_common.h"

module top();

  parameter HIGH = 1'b1;
  parameter LOW  = 1'b0;
  parameter UNK  = 1'bx;

  reg               rst;
  reg               clk;


  /* include test vector */
`include "pattern.v"


  reg              cs;
  reg              we;
  reg     [ 5:0]   adr;
  reg     [31:0]   din;
  wire    [31:0]   dout;

  /* dut */
  sp1_ram #(AW, DW, DS) ram(
    .rst(rst),
    .clk(clk),
    .cs(cs),
    .we(we),
    .adr(adr),
    .din(din),
    .dout(dout)
  );



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
    cs = LOW;
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


  /* monitor */
  initial begin
    $monitor("monitor   : %7d: %b %b %b %h %h %h",
             $time, rst, cs, we, adr, din, dout);
  end


  /* write to ram */
  task write_ram;
    input   [ 5:0]   i_adr;
    input   [31:0]   i_din;
    begin
      @(negedge clk);
      #1;
      cs  = HIGH;
      we  = HIGH;
      adr = i_adr;
      din = i_din;
      $display("write_ram : %7d: (adr,din) <- (%h, %h)", $time, i_adr, i_din);

      @(posedge clk);
      #1;
      cs  = LOW;
      we  = UNK;
      adr = {6{UNK}};
      din = {32{UNK}};
    end
  endtask


  /* read from ram */
  task read_ram;
    input   [ 5:0]   i_adr;
    begin
      @(negedge clk);
      #1;
      cs  = HIGH;
      we  = LOW;
      adr = i_adr;
      $display("read_ram  : %7d: (adr) <- (%h)", $time, i_adr);

      @(posedge clk);
      #1;
      cs  = LOW;
      we  = UNK;
      adr = {6{UNK}};
      $display("read_ram  : %7d: (dout) -> (%h)", $time, dout);
    end
  endtask


  /* finish */
  task halt;
    begin
      repeat(5) @(posedge clk);
      $finish;
    end
  endtask

endmodule
