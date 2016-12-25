

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
  reg     [AW-1:0] adrs;
  reg     [DW-1:0] din;
  wire    [DW-1:0] dout;

  /* dut */
  sp1_ram #(AW, DW, DS) ram(
    .rst(rst),
    .clk(clk),
    .cs(cs),
    .we(we),
    .adrs(adrs),
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
             $time, rst, cs, we, adrs, din, dout);
  end


  /* ram test tasks */
  task test_ram;
    begin
      /* basic data */
      repeat(2) @(posedge clk);
      read_ram({AW{LOW}});

      @(posedge clk);
      write_ram({AW{LOW}}, 32'hffffffff);
      read_ram({AW{LOW}});

      @(posedge clk);
      write_ram({AW{LOW}}, 32'h00000000);
      read_ram({AW{LOW}});

      @(posedge clk);
      write_ram({AW{LOW}}, 32'h12345678);
      read_ram({AW{LOW}});

      @(posedge clk);
      write_ram({AW{LOW}}, 32'hcafecafe);
      read_ram({AW{LOW}});


      /* basic address */
      @(posedge clk);
      write_ram({AW{LOW}}, 32'hcafecafe);
      read_ram({AW{LOW}});

      @(posedge clk);
      write_ram({AW{HIGH}}, 32'hbeefbeef);
      read_ram({AW{HIGH}});


      /* sequence */
      @(posedge clk);
      write_ram('h1, 32'h33333333);
      write_ram('h2, 32'hcccccccc);
      write_ram('h3, 32'h55555555);
      write_ram('h4, 32'haaaaaaaa);
      read_ram('h1);
      read_ram('h2);
      read_ram('h3);
      read_ram('h4);


      /* unknown cs */
      @(posedge clk);
      write_ram({AW{LOW}}, 32'hbeefcafe);
      read_ram({AW{LOW}});
      unk_cs_ram();
      read_ram({AW{LOW}});


      /* unknown we */
      @(posedge clk);
      write_ram({AW{HIGH}}, 32'hcafebeef);
      read_ram({AW{HIGH}});
      unk_we_ram();
      read_ram({AW{HIGH}});
    end
  endtask


  /* write to ram */
  task write_ram;
    input   [AW-1:0]   i_adrs;
    input   [DW-1:0]   i_din;
    begin
      @(negedge clk);
      #1;
      cs   = HIGH;
      we   = HIGH;
      adrs = i_adrs;
      din  = i_din;
      $display("write_ram : %7d: (adrs,din) <- (%h, %h)", $time, i_adrs, i_din);

      @(posedge clk);
      #1;
      cs   = LOW;
      we   = UNK;
      adrs = {AW{UNK}};
      din  = {DW{UNK}};
    end
  endtask


  /* read from ram */
  task read_ram;
    input   [AW-1:0]   i_adrs;
    begin
      @(negedge clk);
      #1;
      cs   = HIGH;
      we   = LOW;
      adrs = i_adrs;
      $display("read_ram  : %7d: (adrs) <- (%h)", $time, i_adrs);

      @(posedge clk);
      #1;
      cs   = LOW;
      we   = UNK;
      adrs = {AW{UNK}};
      $display("read_ram  : %7d: (dout) -> (%h)", $time, dout);
    end
  endtask


  /* unknown cs to ram */
  task unk_cs_ram;
    begin
      @(negedge clk);
      #1;
      cs   = UNK;
      we   = HIGH;
      adrs = {AW{LOW}};
      din  = {DW{LOW}};
      $display("unk_cs_ram : %7d: (adrs,din) <- (%h, %h)", $time, adrs, din);

      @(posedge clk);
      #1;
      cs   = LOW;
      we   = UNK;
      adrs = {AW{UNK}};
      din  = {DW{UNK}};
    end
  endtask


  /* unknown we to ram */
  task unk_we_ram;
    begin
      @(negedge clk);
      #1;
      cs   = HIGH;
      we   = UNK;
      adrs = {AW{HIGH}};
      din  = {DW{HIGH}};
      $display("unk_cs_ram : %7d: (adrs,din) <- (%h, %h)", $time, adrs, din);

      @(posedge clk);
      #1;
      cs   = LOW;
      we   = UNK;
      adrs = {AW{UNK}};
      din  = {DW{UNK}};
    end
  endtask


  /* dump ram */
  task dump_ram;
    integer fm, i;
    begin

      @(posedge clk);
      #1;
      $display("dump_ram  : dump memory");

      fm = $fopen("heap.dump");
      for (i=0; i<DS; i=i+1) begin
        $fdisplay(fm, "%h: %h", i, top.ram.mem[i]);
      end
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
