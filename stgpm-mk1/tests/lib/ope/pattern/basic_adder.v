

`define SP1_ADDER

  parameter DW = 32;


  /* test pattern */

  initial begin
    @(negedge rst);
    repeat(2) @(posedge clk);

    @(posedge clk);
    a0 = 'd1;
    a1 = 'd2;

    @(posedge clk);
    a0 = 32'h1234_5678;
    a1 = 32'h1111_1111;

    @(posedge clk);
    a0 = 32'hffff_fffe;
    a1 = 32'h0000_0001;

    /* carry */
    @(posedge clk);
    a0 = 32'hffff_ffff;
    a1 = 32'h0000_0001;

    repeat(5) @(posedge clk);
    halt();
  end


