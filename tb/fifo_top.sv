import uvm_pkg::*;
`include "uvm_macros.svh"
`include "uvm_includes.sv"
module tb_top;

    bit clk;
    bit rst_n;

    always #5 clk = ~clk;

    fifo_if vif(clk, rst_n);

   sync_fifo #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(4)
   ) dut (
        .clk(vif.clk),
        .rst_n(vif.rst_n),
        .wr_en(vif.wr_en),
        .rd_en(vif.rd_en),
        .wdata(vif.wdata),
        .rdata(vif.rdata),
        .full(vif.full),
        .empty(vif.empty)
    );

    initial begin
        clk = 0;
        rst_n = 0;
        #20 rst_n = 1;
    end

    initial begin
        uvm_config_db#(virtual fifo_if)::set(null, "*", "vif", vif);

        run_test("fifo_base_test");
    end

    initial begin
        $dumpfile("dump.vcd"); 
        $dumpvars(0, tb_top);
    end

endmodule