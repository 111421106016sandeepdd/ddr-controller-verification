`timescale 1ns/1ps

module tb_ddr_env;

  logic        clk;
  logic        rst;
  logic        write_en;
  logic        read_en;
  logic [7:0]  addr;
  logic [31:0] wdata;
  logic [31:0] rdata;

  integer errors;
  integer i;

  // Transaction storage: simple arrays (Icarus-friendly)
  logic        txn_is_write [0:15];
  logic [7:0]  txn_addr     [0:15];
  logic [31:0] txn_data     [0:15];

  logic [31:0] exp_mem [0:255];
  logic [31:0] observed_data;

  // DUT
  ddr_controller dut (
      .clk(clk),
      .rst(rst),
      .write_en(write_en),
      .read_en(read_en),
      .addr(addr),
      .wdata(wdata),
      .rdata(rdata)
  );

  // Clock
  initial clk = 0;
  always #5 clk = ~clk;

  // Waveform
  initial begin
    $dumpfile("build/ddr_verif_env.vcd");
    $dumpvars(0, tb_ddr_env);
  end

  // -----------------------------
  // Generator
  // -----------------------------
  task generator;
    begin
      $display("GENERATOR : creating transactions");

      // Directed tests
      txn_is_write[0] = 0; txn_addr[0] = 8'h30; txn_data[0] = 32'h00000000; // empty read
      txn_is_write[1] = 1; txn_addr[1] = 8'h10; txn_data[1] = 32'h1234ABCD;
      txn_is_write[2] = 0; txn_addr[2] = 8'h10; txn_data[2] = 32'h1234ABCD;
      txn_is_write[3] = 1; txn_addr[3] = 8'h20; txn_data[3] = 32'hDEADBEEF;
      txn_is_write[4] = 0; txn_addr[4] = 8'h20; txn_data[4] = 32'hDEADBEEF;
      txn_is_write[5] = 1; txn_addr[5] = 8'h10; txn_data[5] = 32'hCAFEBABE;
      txn_is_write[6] = 0; txn_addr[6] = 8'h10; txn_data[6] = 32'hCAFEBABE;

      // Randomized write/read pairs
      for (i = 7; i < 15; i = i + 2) begin
        txn_is_write[i]   = 1'b1;
        txn_addr[i]       = $random;
        txn_data[i]       = $random;

        txn_is_write[i+1] = 1'b0;
        txn_addr[i+1]     = txn_addr[i];
        txn_data[i+1]     = txn_data[i];
      end
    end
  endtask

  // -----------------------------
  // Driver
  // -----------------------------
  task driver(
      input logic is_write,
      input logic [7:0] t_addr,
      input logic [31:0] t_data
  );
    begin
      @(posedge clk);
      addr <= t_addr;

      if (is_write) begin
        wdata    <= t_data;
        write_en <= 1'b1;
        read_en  <= 1'b0;
        $display("DRIVER    : WRITE addr=%h data=%h time=%0t", t_addr, t_data, $time);
      end
      else begin
        write_en <= 1'b0;
        read_en  <= 1'b1;
        $display("DRIVER    : READ  addr=%h exp=%h time=%0t", t_addr, t_data, $time);
      end

      @(posedge clk);
      write_en <= 1'b0;
      read_en  <= 1'b0;
    end
  endtask

  // -----------------------------
  // Monitor
  // -----------------------------
  task monitor(
      input logic is_write,
      input logic [7:0] t_addr,
      input logic [31:0] t_data,
      output logic [31:0] observed
  );
    begin
      observed = 32'h00000000;

      if (is_write) begin
        observed = t_data;
        $display("MONITOR   : WRITE observed addr=%h data=%h time=%0t", t_addr, t_data, $time);
      end
      else begin
        #1;
        observed = rdata;
        $display("MONITOR   : READ  observed addr=%h data=%h time=%0t", t_addr, observed, $time);
      end
    end
  endtask

  // -----------------------------
  // Scoreboard
  // -----------------------------
  task scoreboard(
      input logic is_write,
      input logic [7:0] t_addr,
      input logic [31:0] t_data,
      input logic [31:0] observed
  );
    logic [31:0] expected;
    begin
      if (is_write) begin
        exp_mem[t_addr] = t_data;
        $display("SCOREBOARD: WRITE recorded addr=%h data=%h", t_addr, t_data);
      end
      else begin
        expected = exp_mem[t_addr];
        if (observed !== expected) begin
          $display("SCOREBOARD: FAIL addr=%h expected=%h got=%h", t_addr, expected, observed);
          errors = errors + 1;
        end
        else begin
          $display("SCOREBOARD: PASS addr=%h expected=%h got=%h", t_addr, expected, observed);
        end
      end
    end
  endtask

  initial begin
    rst      = 1'b1;
    write_en = 1'b0;
    read_en  = 1'b0;
    addr     = 8'h00;
    wdata    = 32'h00000000;
    errors   = 0;

    for (i = 0; i < 256; i = i + 1)
      exp_mem[i] = 32'h00000000;

    $display("SIM START: Structured DDR Verification Environment");

    // Reset
    repeat (2) @(posedge clk);
    rst = 1'b0;

    // Generate transactions
    generator();

    // Apply, monitor, check
    for (i = 0; i < 15; i = i + 1) begin
      driver(txn_is_write[i], txn_addr[i], txn_data[i]);
      monitor(txn_is_write[i], txn_addr[i], txn_data[i], observed_data);
      scoreboard(txn_is_write[i], txn_addr[i], txn_data[i], observed_data);
    end

    if (errors == 0)
      $display("ALL TESTS PASSED");
    else
      $display("TESTS FAILED: errors=%0d", errors);

    #20;
    $finish;
  end

endmodule
