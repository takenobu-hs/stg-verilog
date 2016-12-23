

`define SP1_DEC


  /* test pattern */

  initial begin
    @(negedge rst);
    repeat(2) @(posedge clk);

    @(posedge clk) #1 e = 3'd0;
    @(posedge clk) #1 e = 3'd1;
    @(posedge clk) #1 e = 3'd2;
    @(posedge clk) #1 e = 3'd3;
    @(posedge clk) #1 e = 3'd4;
    @(posedge clk) #1 e = 3'd5;
    @(posedge clk) #1 e = 3'd6;
    @(posedge clk) #1 e = 3'd7;
    @(posedge clk) #1 e = 3'bxxx;
    @(posedge clk) #1 e = 3'd0;

    repeat(5) @(posedge clk);
    halt();
  end


