

`include "sp1_common.h"


module top();

  parameter DW = `SP1_WORD_WIDTH;               // data width

  parameter HIGH = 1'b1;
  parameter LOW  = 1'b0;
  parameter UNK  = 1'bx;

  parameter EN = 1'b1;
  parameter NO = 1'b0;
  parameter WT = 1'b1;
  parameter RD = 1'b0;
  parameter SINGLE = 1'b0;
  parameter DOUBLE = 1'b1;

  reg               rst;
  reg               clk;


  /* include test vector */
`include "pattern.v"


  reg               h5_hmem_acs_en;
  reg               h5_hmem_acs_type;
  reg               h5_hmem_acs_sz;
  reg     [DW-1:0]  h5_hmem_acs_adrs;
  reg     [DW-1:0]  h5_hmem_wr_dt0;
  reg     [DW-1:0]  h5_hmem_wr_dt1;
  wire    [DW-1:0]  h6_hmem_rd_dt0;
  wire    [DW-1:0]  h6_hmem_rd_dt1;


  /* dut */
  sp1_hmem_heap hmem_heap(
    .rst(rst),
    .clk(clk),
    .h5_hmem_acs_en(h5_hmem_acs_en),
    .h5_hmem_acs_type(h5_hmem_acs_type),
    .h5_hmem_acs_sz(h5_hmem_acs_sz),
    .h5_hmem_acs_adrs(h5_hmem_acs_adrs),
    .h5_hmem_wr_dt0(h5_hmem_wr_dt0),
    .h5_hmem_wr_dt1(h5_hmem_wr_dt1),
    .h6_hmem_rd_dt0(h6_hmem_rd_dt0),
    .h6_hmem_rd_dt1(h6_hmem_rd_dt1)
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
    rst   = HIGH;
    h5_hmem_acs_en = LOW;
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
    $monitor("monitor   : %7d: %b  %b %b %b  %h  %h %h  %h %h",
             $time, rst, 
             h5_hmem_acs_en, h5_hmem_acs_type, h5_hmem_acs_sz,
             h5_hmem_acs_adrs,
             h5_hmem_wr_dt0, h5_hmem_wr_dt1, h6_hmem_rd_dt0, h6_hmem_rd_dt1);
  end



  /* heap test tasks */
  task test_heap;
    begin
      repeat(2) @(posedge clk);

      // read non-initialized value
      test_mark(0);
      load_heap('h000, DOUBLE);

      // single access
      test_mark(10);
      store_heap('h010, SINGLE, 32'h01234567, {DW{UNK}});
      load_heap ('h010, SINGLE);
      store_heap('h024, SINGLE, 32'h89abcdef, {DW{UNK}});
      load_heap ('h024, SINGLE);

      // double access
      test_mark(20);
      store_heap('h030, DOUBLE, 32'h11111111, 32'h22222222);
      load_heap ('h030, DOUBLE);
      store_heap('h044, DOUBLE, 32'h33333333, 32'h44444444);
      load_heap ('h044, DOUBLE);
      store_heap('h058, DOUBLE, 32'h55555555, 32'h66666666);
      load_heap ('h058, DOUBLE);
      store_heap('h06c, DOUBLE, 32'h77777777, 32'h88888888);
      load_heap ('h06c, DOUBLE);

      // tail access
      test_mark(30);
      store_heap('hff8, DOUBLE, 32'hf0f0f0f0, 32'hf1f1f1f1);
      load_heap ('hff8, DOUBLE);

      // sequential single access
      test_mark(40);
      store_heap('h070, SINGLE, 32'h01010101, {DW{UNK}});
      store_heap('h074, SINGLE, 32'h02020202, {DW{UNK}});
      store_heap('h078, SINGLE, 32'h03030303, {DW{UNK}});
      store_heap('h07c, SINGLE, 32'h04040404, {DW{UNK}});
      load_heap ('h070, SINGLE);
      load_heap ('h074, SINGLE);
      load_heap ('h078, SINGLE);
      load_heap ('h07c, SINGLE);

      test_mark(50);
      store_heap('h080, DOUBLE, 32'h00010001, 32'h00010002);
      store_heap('h088, DOUBLE, 32'h00010003, 32'h00010004);
      store_heap('h090, DOUBLE, 32'h00010005, 32'h00010006);
      store_heap('h098, DOUBLE, 32'h00010007, 32'h00010008);
      load_heap ('h080, DOUBLE);
      load_heap ('h088, DOUBLE);
      load_heap ('h090, DOUBLE);
      load_heap ('h098, DOUBLE);

      test_mark(60);
      store_heap('h0a4, DOUBLE, 32'h00020001, 32'h00020002);
      store_heap('h0ac, DOUBLE, 32'h00020003, 32'h00020004);
      store_heap('h0b4, DOUBLE, 32'h00020005, 32'h00020006);
      store_heap('h0bc, DOUBLE, 32'h00020007, 32'h00020008);
      load_heap ('h0a4, DOUBLE);
      load_heap ('h0ac, DOUBLE);
      load_heap ('h0b4, DOUBLE);
      load_heap ('h0bc, DOUBLE);
    end
  endtask


  /* store to heap */
  task store_heap;
    input   [DW-1:0]   i_adrs;
    input              i_sz;
    input   [DW-1:0]   i_din0;
    input   [DW-1:0]   i_din1;
    begin
      @(negedge clk);
      #1;
      h5_hmem_acs_en = HIGH;
      h5_hmem_acs_type = WT;
      h5_hmem_acs_sz = i_sz;
      h5_hmem_acs_adrs = i_adrs;
      h5_hmem_wr_dt0 = i_din0;
      h5_hmem_wr_dt1 = i_din1;
      $display("store_heap: %7d: <- (%h,%b, %h,%h)",
               $time, i_adrs, i_sz, i_din0, i_din1);

      @(posedge clk);
      #1;
      h5_hmem_acs_en = LOW;
      h5_hmem_acs_type = UNK;
      h5_hmem_acs_sz = UNK;
      h5_hmem_acs_adrs = {DW{UNK}};
      h5_hmem_wr_dt0 = {DW{UNK}};
      h5_hmem_wr_dt1 = {DW{UNK}};
    end
  endtask

  /* load from heap */
  task load_heap;
    input   [DW-1:0]   i_adrs;
    input              i_sz;
    begin
      @(negedge clk);
      #1;
      h5_hmem_acs_en = HIGH;
      h5_hmem_acs_type = RD;
      h5_hmem_acs_sz = i_sz;
      h5_hmem_acs_adrs = i_adrs;
      $display("load_heap : %7d: <- (%h,%b)",
               $time, i_adrs, i_sz);

      @(posedge clk);
      #1;
      h5_hmem_acs_en = LOW;
      h5_hmem_acs_type = UNK;
      h5_hmem_acs_sz = UNK;
      h5_hmem_acs_adrs = {DW{UNK}};
    end
  endtask


  /* display mark */
  task test_mark;
    input   [31:0]   num;
    begin
      @(posedge clk);
      #1;
      $display("test_mark : %d#", num);
    end
  endtask


  /* dump ram */
  task dump_heap;
    integer fm, i;
    begin
      @(posedge clk);
      #1;
      $display("dump_ram  : dump memory");

      fm = $fopen("mem.hmdump");
      for (i=0; i<(`SP1_HEAP_WORDS/2); i=i+1) begin
        $fdisplay(fm, "%04h: %h %h",
                  i*(`SP1_WORD_BYTES*2),
                  top.hmem_heap.hmem_dualram.mem_ev.mem[i],
                  top.hmem_heap.hmem_dualram.mem_od.mem[i]);
      end
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
