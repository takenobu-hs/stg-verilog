



  /* test pattern */

  initial begin
    @(negedge rst);

    repeat(2) @(posedge clk);
    test_heap();

    repeat(2) @(posedge clk);
    dump_heap();

    repeat(5) @(posedge clk);
    halt();
  end


