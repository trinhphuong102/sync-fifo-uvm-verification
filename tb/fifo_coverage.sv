class fifo_coverage extends uvm_subscriber #(fifo_transaction);
    `uvm_component_utils(fifo_coverage)

    fifo_transaction tr;

    covergroup cg_fifo;
        cp_wr_en: coverpoint tr.wr_en;
        cp_rd_en: coverpoint tr.rd_en;
        cp_full:  coverpoint tr.full;
        cp_empty: coverpoint tr.empty;
    endgroup

    function new(string name = "fifo_coverage", uvm_component parent);
        super.new(name, parent);
        cg_fifo = new(); 
    endfunction

    virtual function void write(fifo_transaction t);
        this.tr = t;
        cg_fifo.sample();
    endfunction

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("COV_REPORT", $sformatf("FIFO Functional Coverage: %0.2f%%", cg_fifo.get_inst_coverage()), UVM_NONE)
    endfunction

endclass