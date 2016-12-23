

`define SP1_FF

  parameter DW = 1;


  /* test pattern */

  initial begin
    sp1_ff_en = LOW;
    sp1_ff_d = {DW{UNK}};

    @(negedge rst);

    repeat(2) @(posedge clk);
    test_ff();

    repeat(5) @(posedge clk);
    halt();
  end


