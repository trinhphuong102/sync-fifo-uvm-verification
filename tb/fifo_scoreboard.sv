class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)

    uvm_analysis_imp #(fifo_transaction, fifo_scoreboard) ap_imp;
    bit [7:0] golden_queue[$];
    int match_count = 0;
    int error_count = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_imp = new("ap_imp", this);
    endfunction

    virtual function void write(fifo_transaction tr);
    bit [7:0] expected_data;

    if (tr.rd_en && !tr.empty) begin
        if (golden_queue.size() == 0) begin
            `uvm_error("SCB", "Read but golden queue empty!")
            error_count++;
        end else begin
            expected_data = golden_queue.pop_front();
            if (tr.rdata === expected_data) begin
                `uvm_info("SCB", $sformatf("PASS! Actual = 0x%0h, Expected = 0x%0h", tr.rdata, expected_data), UVM_HIGH)
                match_count++;
            end else begin
                `uvm_error("SCB", $sformatf("FAIL! Actual = 0x%0h, Expected = 0x%0h", tr.rdata, expected_data))
                error_count++;
            end
        end
    end

    if (tr.wr_en && !tr.full) begin
        golden_queue.push_back(tr.wdata);
        `uvm_info("SCB", $sformatf("Expected data added: 0x%0h", tr.wdata), UVM_HIGH)
    end
endfunction

    virtual function void report_phase(uvm_phase phase);
        `uvm_info("SCB", "--------------------------------------", UVM_LOW)
        `uvm_info("SCB", $sformatf("FINAL REPORT: Matches: %0d, Errors: %0d", match_count, error_count), UVM_LOW)
        `uvm_info("SCB", "--------------------------------------", UVM_LOW)
    endfunction

endclass