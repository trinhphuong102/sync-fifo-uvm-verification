import uvm_pkg::*;
`include "uvm_macros.svh"
class fifo_transaction extends uvm_sequence_item;

    rand bit wr_en , rd_en ;
    rand bit [7:0] wdata ;

    bit empty , full ;
    bit [7:0] rdata ;

    constraint ctrl_c {
        wr_en dist {1'b1 := 70 , 1'b0 := 30};
        rd_en dist {1'b1 := 50 , 1'b0 := 50};
    }

    `uvm_object_utils_begin(fifo_transaction)
        `uvm_field_int(wr_en, UVM_ALL_ON)
        `uvm_field_int(rd_en, UVM_ALL_ON)
        `uvm_field_int(wdata, UVM_ALL_ON)
        `uvm_field_int(full,  UVM_ALL_ON)
        `uvm_field_int(empty, UVM_ALL_ON)
        `uvm_field_int(rdata, UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = "fifo_transaction");
        super.new(name);
    endfunction

endclass