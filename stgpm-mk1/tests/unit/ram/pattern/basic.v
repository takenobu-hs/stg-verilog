

  /* test patter */

  initial begin

    repeat(2) @(posedge clk);
    write_ram(6'h10, 32'hcafebeef);

    repeat(2) @(posedge clk);
    write_ram(6'h12, 32'h0bad0bad);

    repeat(2) @(posedge clk);
    read_ram(6'h10);

    repeat(2) @(posedge clk);
    halt();

  end


