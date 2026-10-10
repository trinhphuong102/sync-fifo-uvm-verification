class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env)

    fifo_agent      agent;
    fifo_scoreboard scb;

    function new(string name = "fifo_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        agent = fifo_agent::type_id::create("agent", this);
        scb   = fifo_scoreboard::type_id::create("scb", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        agent.monitor.mon_ap.connect(scb.ap_imp);
    endfunction

endclass