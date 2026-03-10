`timescale 1ns/1ps

module tb_ddr_controller;

    logic        clk;
    logic        rst;
    logic        write_en;
    logic        read_en;
    logic [7:0]  addr;
    logic [31:0] wdata;
    logic [31:0] rdata;

    integer errors;

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

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Waveform dump
    initial begin
        $dumpfile("build/ddr_verif.vcd");
        $dumpvars(0, tb_ddr_controller);
    end

    // Simple write task
    task do_write(input [7:0] a, input [31:0] d);
    begin
        @(posedge clk);
        addr     <= a;
        wdata    <= d;
        write_en <= 1'b1;
        read_en  <= 1'b0;

        @(posedge clk);
        write_en <= 1'b0;

        $display("WRITE: addr=%h data=%h time=%0t", a, d, $time);
    end
    endtask

    // Simple read+check task
    task do_read_check(input [7:0] a, input [31:0] exp);
    begin
        @(posedge clk);
        addr     <= a;
        read_en  <= 1'b1;
        write_en <= 1'b0;

        @(posedge clk);
        read_en <= 1'b0;

        // Wait one small delta for rdata to settle in sim display
        #1;
        $display("READ : addr=%h data=%h expected=%h time=%0t", a, rdata, exp, $time);

        if (rdata !== exp) begin
            $display("FAIL: addr=%h expected=%h got=%h", a, exp, rdata);
            errors = errors + 1;
        end
        else begin
            $display("PASS: addr=%h data matched", a);
        end
    end
    endtask

    initial begin
        // init
        rst      = 1'b1;
        write_en = 1'b0;
        read_en  = 1'b0;
        addr     = 8'h00;
        wdata    = 32'h00000000;
        errors   = 0;

        $display("SIM START: DDR Controller Verification");

        // Reset
        repeat (2) @(posedge clk);
        rst = 1'b0;

        // Test 1: empty memory read
        do_read_check(8'h30, 32'h00000000);

        // Test 2: write then read
        do_write(8'h10, 32'h1234ABCD);
        do_read_check(8'h10, 32'h1234ABCD);

        // Test 3: another write/read
        do_write(8'h20, 32'hDEADBEEF);
        do_read_check(8'h20, 32'hDEADBEEF);

        // Test 4: overwrite same location
        do_write(8'h10, 32'hCAFEBABE);
        do_read_check(8'h10, 32'hCAFEBABE);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: errors=%0d", errors);

        #20;
        $finish;
    end

endmodule
