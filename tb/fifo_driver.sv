class fifo_driver extends uvm_driver #(fifo_transaction);
`uvm_component_utils(fifo_driver)

    function new(string name = "fifo_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual fifo_if vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("DRV", "Could not get vif from config_db");
        end
    endfunction

 virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        vif.driver_cb.wr_en <= 1'b0;
        vif.driver_cb.rd_en <= 1'b0;
        vif.driver_cb.wdata <= '0;
        @(vif.driver_cb); 
   
        forever begin
            wait(vif.rst_n === 1);
            seq_item_port.get_next_item(req);
            
            vif.driver_cb.wr_en <= req.wr_en;
            vif.driver_cb.rd_en <= req.rd_en;
            vif.driver_cb.wdata <= req.wdata;

            @(vif.driver_cb);
            vif.driver_cb.wr_en <= 1'b0;
            vif.driver_cb.rd_en <= 1'b0;
            
            seq_item_port.item_done();
        end
    endtask
endclass