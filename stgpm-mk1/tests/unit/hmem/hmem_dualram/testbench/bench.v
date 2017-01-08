

`include "sp1_common.h"


module top();

  parameter DW = `SP1_WORD_WIDTH;               // data width

  parameter HIGH = 1'b1;
  parameter LOW  = 1'b0;
  parameter UNK  = 1'bx;

  parameter WT = 1'b1;
  parameter RD = 1'b0;
  parameter EN = 1'b1;
  parameter NO = 1'b0;

  reg               rst;
  reg               clk;


  /* include test vector */
`include "pattern.v"


  reg               cs_ev;
  reg               cs_od;
  reg               we_ev;
  reg               we_od;
  reg     [DW-1:0]  adrs_ev;
  reg     [DW-1:0]  adrs_od;
  reg     [DW-1:0]  wr_dt_ev;
  reg     [DW-1:0]  wr_dt_od;
  wire    [DW-1:0]  rd_dt_ev;
  wire    [DW-1:0]  rd_dt_od;


  /* dut */
  sp1_hmem_dualram hmem_dualram(
    .rst(rst),
    .clk(clk),
    .cs_ev(cs_ev),
    .cs_od(cs_od),
    .we_ev(we_ev),
    .we_od(we_od),
    .adrs_ev(adrs_ev),
    .adrs_od(adrs_od),
    .wr_dt_ev(wr_dt_ev),
    .wr_dt_od(wr_dt_od),
    .rd_dt_ev(rd_dt_ev),
    .rd_dt_od(rd_dt_od)
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
    cs_ev = LOW;
    cs_od = LOW;
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
    $monitor("monitor   : %7d: %b %b %b %b %b  %h %h  %h %h  %h %h",
             $time, rst, cs_ev, cs_od, we_ev, we_od, adrs_ev, adrs_od,
             wr_dt_ev, wr_dt_od, rd_dt_ev, rd_dt_od);
  end


  /* heap test tasks */
  task test_heap;
    begin
      repeat(2) @(posedge clk);

      // read non-initialized value
      test_mark(0);
      acs_heap(EN, RD, 'h000, {32{UNK}},
               EN, RD, 'h000, {32{UNK}});

      // access to head and tail
      test_mark(10);
      acs_heap(EN, WT, 'h010,  32'h01234567,
               EN, WT, 'h014,  32'h89abcdef);
      acs_heap(EN, RD, 'h010,  {32{UNK}},
               EN, RD, 'h014,  {32{UNK}});
      acs_heap(EN, WT, 'hff8,  32'hfedcba98,
               EN, WT, 'hffc,  32'h76543210);
      acs_heap(EN, RD, 'hff8,  {32{UNK}},
               EN, RD, 'hffc,  {32{UNK}});

      // acess with sub word addressing
      test_mark(20);
      acs_heap(EN, WT, 'h021,  32'h22222222,
               NO, WT, 'h021,  {32{UNK}});
      acs_heap(EN, RD, 'h021,  {32{UNK}},
               NO, WT, 'h021,  {32{UNK}});

      acs_heap(EN, WT, 'h032,  32'h33333333,
               NO, WT, 'h032,  {32{UNK}});
      acs_heap(EN, RD, 'h032,  {32{UNK}},
               NO, WT, 'h032,  {32{UNK}});

      acs_heap(EN, WT, 'h043,  32'h44444444,
               NO, WT, 'h043,  {32{UNK}});
      acs_heap(EN, RD, 'h043,  {32{UNK}},
               NO, WT, 'h043,  {32{UNK}});

      acs_heap(EN, WT, 'h054,  32'h55555555,
               NO, WT, 'h054,  {32{UNK}});
      acs_heap(EN, RD, 'h054,  {32{UNK}},
               NO, WT, 'h054,  {32{UNK}});

      // even odd
      test_mark(30);
      acs_heap(EN, WT, 'h060,  32'h60606060,
               EN, WT, 'h064,  32'h61616161);
      acs_heap(EN, RD, 'h060,  {32{UNK}},
               EN, RD, 'h064,  {32{UNK}});
      acs_heap(EN, WT, 'h070,  32'h70707070,
               NO, WT, 'h074,  32'h71717171);
      acs_heap(EN, RD, 'h070,  {32{UNK}},
               EN, RD, 'h074,  {32{UNK}});
      acs_heap(NO, WT, 'h080,  32'h80808080,
               EN, WT, 'h084,  32'h81818181);
      acs_heap(EN, RD, 'h080,  {32{UNK}},
               EN, RD, 'h084,  {32{UNK}});
      acs_heap(NO, WT, 'h090,  32'h90909090,
               NO, WT, 'h094,  32'h91919191);
      acs_heap(EN, RD, 'h090,  {32{UNK}},
               EN, RD, 'h094,  {32{UNK}});

      // sequencial access
      test_mark(30);
      acs_heap(EN, WT, 'h0a0,  32'ha0a0a0a0,
               EN, WT, 'h0a4,  32'ha1a1a1a1);
      acs_heap(EN, WT, 'h0a8,  32'ha8a8a8a8,
               EN, WT, 'h0ac,  32'ha9a9a9a9);
      acs_heap(EN, WT, 'h0b0,  32'hb0b0b0b0,
               EN, WT, 'h0b4,  32'hb1b1b1b1);
      acs_heap(EN, WT, 'h0b8,  32'hb8b8b8b8,
               EN, WT, 'h0bc,  32'hb9b9b9b9);
      acs_heap(EN, RD, 'h0a0,  {32{UNK}},
               EN, RD, 'h0a4,  {32{UNK}});
      acs_heap(EN, RD, 'h0a8,  {32{UNK}},
               EN, RD, 'h0ac,  {32{UNK}});
      acs_heap(EN, RD, 'h0b0,  {32{UNK}},
               EN, RD, 'h0b4,  {32{UNK}});
      acs_heap(EN, RD, 'h0b8,  {32{UNK}},
               EN, RD, 'h0bc,  {32{UNK}});
    end
  endtask


  /* access to heap */
  task acs_heap;
    input              i_cs_ev;
    input              i_we_ev;
    input   [DW-1:0]   i_adrs_ev;
    input   [DW-1:0]   i_din_ev;
    input              i_cs_od;
    input              i_we_od;
    input   [DW-1:0]   i_adrs_od;
    input   [DW-1:0]   i_din_od;
    begin
      @(negedge clk);
      #1;
      cs_ev    = i_cs_ev;
      cs_od    = i_cs_od;
      we_ev    = i_we_ev;
      we_od    = i_we_od;
      adrs_ev  = i_adrs_ev;
      adrs_od  = i_adrs_od;
      wr_dt_ev = i_din_ev;
      wr_dt_od = i_din_od;
      $display("write_ram : %7d: <- (%b,%b, %b,%b, %h,%h, %h,%h)",
               $time, cs_ev, cs_od, we_ev, we_od,
               i_adrs_ev, i_adrs_od, i_din_ev, i_din_od);

      @(posedge clk);
      #1;

      cs_ev    = LOW;
      cs_od    = LOW;
      we_ev    = UNK;
      we_od    = UNK;
      adrs_ev  = {DW{UNK}};
      adrs_od  = {DW{UNK}};
      wr_dt_ev = {DW{UNK}};
      wr_dt_od = {DW{UNK}};
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
                  top.hmem_dualram.mem_ev.mem[i],
                  top.hmem_dualram.mem_od.mem[i]);
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
