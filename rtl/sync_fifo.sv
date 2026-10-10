module sync_fifo #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    input  logic clk,
    input  logic rst_n,
    
    input  logic wr_en,
    input  logic [DATA_WIDTH-1:0] wdata,
    output logic full,
    
    input  logic rd_en,
    output logic [DATA_WIDTH-1:0] rdata,
    output logic empty
);

    logic [DATA_WIDTH-1:0] mem [0:(2**ADDR_WIDTH)-1];
    logic [ADDR_WIDTH:0]   wr_ptr;
    logic [ADDR_WIDTH:0]   rd_ptr;

    assign empty = (wr_ptr == rd_ptr);
    
    assign full  = (wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) && 
                   (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= '0;
            rd_ptr <= '0;
        end else begin
            if (wr_en && !full) begin
                mem[wr_ptr[ADDR_WIDTH-1:0]] <= wdata;
                wr_ptr <= wr_ptr + 1;
            end
            
            if (rd_en && !empty) begin
                rd_ptr <= rd_ptr + 1;
            end
        end
    end

    assign rdata = mem[rd_ptr[ADDR_WIDTH-1:0]];

endmodule