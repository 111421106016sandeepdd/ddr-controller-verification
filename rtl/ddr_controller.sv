`timescale 1ns/1ps
`timescale 1ns/1ps
module ddr_controller (
    input  logic        clk,
    input  logic        rst,

    input  logic        write_en,
    input  logic        read_en,
    input  logic [7:0]  addr,
    input  logic [31:0] wdata,

    output logic [31:0] rdata
);

    logic [31:0] mem [0:255];
    integer i;

    always_ff @(posedge clk) begin
        if (rst) begin
            rdata <= 32'h00000000;
            for (i = 0; i < 256; i = i + 1)
                mem[i] <= 32'h00000000;
        end
        else begin
            if (write_en)
                mem[addr] <= wdata;

            if (read_en)
                rdata <= mem[addr];
        end
    end

endmodule
