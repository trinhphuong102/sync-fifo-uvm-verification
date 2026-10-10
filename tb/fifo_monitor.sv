class fifo_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_monitor)

    virtual fifo_if vif;
    uvm_analysis_port #(fifo_transaction) mon_ap;

    function new(string name = "fifo_monitor", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        mon_ap = new("mon_ap", this);

        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_error("MON", "Could not get vif from config_db")
        end
    endfunction

virtual task run_phase(uvm_phase phase);
    fifo_transaction tr;
    int unsigned tr_count = 0;
    super.run_phase(phase);

    wait(vif.rst_n === 1'b1);

    forever begin
        @(vif.monitor_cb);
        if (vif.rst_n === 1'b0) continue;

        if (vif.monitor_cb.wr_en === 1'b1 || vif.monitor_cb.rd_en === 1'b1) begin
            tr = fifo_transaction::type_id::create("tr");
            tr.wr_en = vif.monitor_cb.wr_en;
            tr.rd_en = vif.monitor_cb.rd_en;
            tr.wdata = vif.monitor_cb.wdata;
            tr.rdata = vif.monitor_cb.rdata;
            tr.full  = vif.monitor_cb.full;
            tr.empty = vif.monitor_cb.empty;

            tr_count++;
            `uvm_info(get_type_name(), $sformatf("Captured transaction #%0d (wr=%0b rd=%0b)", tr_count, tr.wr_en, tr.rd_en), UVM_LOW)
            mon_ap.write(tr);
        end
    end
endtask

endclass