

`define SP1_DECR

  parameter DW = 32;


  /* test pattern */

  initial begin
    @(negedge rst);
    repeat(2) @(posedge clk);

    @(posedge clk);
    a = 'd2;

    @(posedge clk);
    a = 32'h1234_5678;

    @(posedge clk);
    a = 32'h0000_0001;

    /* carry */
    @(posedge clk);
    a = 32'h0000_0000;

    repeat(5) @(posedge clk);
    halt();
  end


