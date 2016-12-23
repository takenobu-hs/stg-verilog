

`define SP1_MUXD

//parameter DW = 32;
  parameter DW = 8;


  /* test pattern */

  initial begin
    @(negedge rst);
    repeat(2) @(posedge clk);

    /* set input data */
    a0 = 'd0;
    a1 = 'd1;
    a2 = 'd2;
    a3 = 'd3;
    a4 = 'd4;
    a5 = 'd5;
    a6 = 'd6;
    a7 = 'd7;

    /* select */
    @(posedge clk) #1 s = 8'b0000_0000;
    @(posedge clk) #1 s = 8'b0000_0001;
    @(posedge clk) #1 s = 8'b0000_0010;
    @(posedge clk) #1 s = 8'b0000_0100;
    @(posedge clk) #1 s = 8'b0000_1000;
    @(posedge clk) #1 s = 8'b0001_0000;
    @(posedge clk) #1 s = 8'b0010_0000;
    @(posedge clk) #1 s = 8'b0100_0000;
    @(posedge clk) #1 s = 8'b1000_0000;
    @(posedge clk) #1 s = 8'bxxxx_xxxx;
    @(posedge clk) #1 s = 8'b0000_0000;
    @(posedge clk) #1 s = 8'b0001_0110;

    repeat(5) @(posedge clk);
    halt();
  end


