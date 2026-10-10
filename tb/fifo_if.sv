interface fifo_if(
    input logic clk, rst_n
    );
    parameter DATA_WIDTH = 8 ;
    logic   wr_en ;
    logic   [DATA_WIDTH-1:0] wdata ;
    logic   full ;
    
    logic   rd_en ;
    logic  [DATA_WIDTH-1:0] rdata ;
    logic  empty ;

clocking driver_cb @(posedge clk) ;
    default input #1step output #0 ;

    output wr_en , wdata , rd_en ;
    input full , empty , rdata ;

endclocking

clocking monitor_cb @(posedge clk);
    default input #1step output #0 ;

    input wdata , wr_en , rd_en , rdata , empty , full;
endclocking

endinterface