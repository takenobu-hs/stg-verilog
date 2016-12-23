

`define SP1_ADDER

  parameter DW = 32;


  /* test pattern */

  initial begin
    @(negedge rst);
    repeat(2) @(posedge clk);

    @(posedge clk);
    a = 'd1;
    b = 'd2;

    @(posedge clk);
    a = 32'h1234_5678;
    b = 32'h1111_1111;

    @(posedge clk);
    a = 32'hffff_fffe;
    b = 32'h0000_0001;

    /* carry */
    @(posedge clk);
    a = 32'hffff_ffff;
    b = 32'h0000_0001;

    repeat(5) @(posedge clk);
    halt();
  end


