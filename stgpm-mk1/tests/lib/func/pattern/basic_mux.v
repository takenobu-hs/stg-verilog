

`define SP1_MUX

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
    @(posedge clk) #1 s = 3'd0;
    @(posedge clk) #1 s = 3'd1;
    @(posedge clk) #1 s = 3'd2;
    @(posedge clk) #1 s = 3'd3;
    @(posedge clk) #1 s = 3'd4;
    @(posedge clk) #1 s = 3'd5;
    @(posedge clk) #1 s = 3'd6;
    @(posedge clk) #1 s = 3'd7;
    @(posedge clk) #1 s = 3'bxxx;
    @(posedge clk) #1 s = 3'd0;

    repeat(5) @(posedge clk);
    halt();
  end


