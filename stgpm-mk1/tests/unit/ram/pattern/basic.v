

  parameter AW = 6;
  parameter DW = 32;
  parameter DS = 1<<AW;


  /* test pattern */

  initial begin
    @(negedge rst);

    repeat(2) @(posedge clk);
    test_ram();

    repeat(5) @(posedge clk);
    halt();
  end


