

  parameter AW = 6;
  parameter DW = 32;
  parameter DS = 1<<AW;


  /* test pattern */

  initial begin
    #1;
    @(negedge rst);

    repeat(2) @(posedge clk);
    write_ram(6'h10, 32'hcafebeef);

    repeat(2) @(posedge clk);
    write_ram(6'h12, 32'h0bad0bad);

    repeat(2) @(posedge clk);
    read_ram(6'h10);

    repeat(2) @(posedge clk);
    halt();

  end


