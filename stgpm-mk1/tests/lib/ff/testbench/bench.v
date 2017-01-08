

`include "sp1_common.h"

module top();


  parameter HIGH = 1'b1;
  parameter LOW  = 1'b0;
  parameter UNK  = 1'bx;

  reg               rst;
  reg               clk;


  /* include test vector */
`include "pattern.v"


`ifdef SP1_FF
  reg               sp1_ff_en;
  reg     [DW-1:0]  sp1_ff_d;
  wire    [DW-1:0]  sp1_ff_q;
 
  /* dut */
  sp1_ff #(DW) sp1_ff(.rst(rst), .clk(clk), .en(sp1_ff_en),
                      .d(sp1_ff_d), .q(sp1_ff_q));

  /* monitor */
  initial begin
    $monitor("monitor   : %7d: %b %b %h %h",
             $time, rst, sp1_ff_en, sp1_ff_d, sp1_ff_q);
  end
`endif // SP1_FF


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


  /* ff test tasks */
  task test_ff;
    begin
      repeat(2) @(posedge clk);
      write_ff(32'hffffffff);

      @(posedge clk);
      write_ff(32'h00000000);

      @(posedge clk);
      write_ff(32'h12345678);

      @(posedge clk);
      write_ff(32'hcafecafe);

      @(posedge clk);
      write_ff(32'h33333333);
      write_ff(32'hcccccccc);
      write_ff(32'h55555555);
      write_ff(32'haaaaaaaa);

      repeat(2) @(posedge clk);
      write_ff_en_unk();

      @(posedge clk);
      write_ff(32'h00000000);

      repeat(2) @(posedge clk);
      write_ff_d_unk();

      @(posedge clk);
      write_ff(32'hbeefbeef);
    end
  endtask


  task write_ff;
    input  [DW-1:0] i_d;
    begin
      @(negedge clk);
      #1;
      sp1_ff_en = HIGH;
      sp1_ff_d  = i_d;
      $display("write_ff : %7d: (en,d) <- (%b, %h)",
               $time, sp1_ff_en, sp1_ff_d);

      @(posedge clk);
      #1;
      sp1_ff_en = LOW;
      sp1_ff_d  = {DW{LOW}};
      $display("write_ff : %7d: (en,d) <- (%b, %h)",
               $time, sp1_ff_en, sp1_ff_d);
    end
  endtask


  task write_ff_en_unk;
    begin
      @(negedge clk);
      #1;
      sp1_ff_en = UNK;
      sp1_ff_d  = 32'hbbbbbbbb;
      $display("write_ff_e_unk : %7d: (en,d) <- (%b, %h)",
               $time, sp1_ff_en, sp1_ff_d);

      @(posedge clk);
      #1;
      sp1_ff_en = LOW;
      sp1_ff_d  = {DW{LOW}};
      $display("write_ff_e_unk : %7d: (en,d) <- (%b, %h)",
               $time, sp1_ff_en, sp1_ff_d);
    end
  endtask


  task write_ff_d_unk;
    begin
      @(negedge clk);
      #1;
      sp1_ff_en = LOW;
      sp1_ff_d  = {32{UNK}};
      $display("write_ff_d_unk : %7d: (en,d) <- (%b, %h)",
               $time, sp1_ff_en, sp1_ff_d);

      @(posedge clk);
      #1;
      sp1_ff_en = LOW;
      sp1_ff_d  = {DW{LOW}};
      $display("write_ff_d_unk : %7d: (en,d) <- (%b, %h)",
               $time, sp1_ff_en, sp1_ff_d);
    end
  endtask



  /* finish */
  task halt;
    begin
      repeat(5) @(posedge clk);
      $display("halt      : halt");
      $finish;
    end
  endtask

endmodule
