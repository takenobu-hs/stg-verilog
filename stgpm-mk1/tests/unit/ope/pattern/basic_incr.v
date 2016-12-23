

`define SP1_INCR

  parameter DW = 32;


  /* test pattern */

  initial begin
    @(negedge rst);
    repeat(2) @(posedge clk);

    @(posedge clk);
    a = 'd1;

    @(posedge clk);
    a = 32'h1234_5678;

    @(posedge clk);
    a = 32'hffff_fffe;

    /* carry */
    @(posedge clk);
    a = 32'hffff_ffff;

    repeat(5) @(posedge clk);
    halt();
  end


