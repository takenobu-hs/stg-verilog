

`define SP1_COMP_EQ

  parameter DW = 32;


  /* test pattern */

  initial begin
    @(negedge rst);
    repeat(2) @(posedge clk);

    @(posedge clk);
    a0 = 32'h0000_0002;
    a1 = 32'h0000_0002;

    @(posedge clk);
    a0 = 32'h0000_0001;
    a1 = 32'h0000_0002;

    @(posedge clk);
    a0 = 32'h0000_0002;
    a1 = 32'h0000_0001;


    @(posedge clk);
    a0 = 32'h0000_0000;
    a1 = 32'hffff_ffff;

    @(posedge clk);
    a0 = 32'hffff_ffff;
    a1 = 32'h0000_0000;

    @(posedge clk);
    a0 = 32'h0000_0000;
    a1 = 32'h0000_0000;

    @(posedge clk);
    a0 = 32'hffff_ffff;
    a1 = 32'hffff_ffff;

    repeat(5) @(posedge clk);
    halt();
  end


