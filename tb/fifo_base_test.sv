class fifo_base_test extends uvm_test;
  `uvm_component_utils(fifo_base_test)

  fifo_env env;

  function new(string name = "fifo_base_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fifo_env::type_id::create("env", this);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("TEST", "UVM Topology:", UVM_LOW)
    this.print();
  endfunction

  virtual task run_phase(uvm_phase phase);
    fifo_sequence seq;

    phase.raise_objection(this);

    `uvm_info("TEST", "--- STAGE 1: RUNNING WRITE_ONLY ---", UVM_LOW)
    seq = fifo_sequence::type_id::create("seq");
    seq.mode = WRITE_ONLY;
    seq.start(env.agent.sequencer);

    `uvm_info("TEST", "--- STAGE 2: RUNNING READ_ONLY ---", UVM_LOW)
    seq = fifo_sequence::type_id::create("seq");
    seq.mode = READ_ONLY;
    seq.start(env.agent.sequencer);

    `uvm_info("TEST", "--- STAGE 3: RUNNING RANDOM_MIX ---", UVM_LOW)
    seq = fifo_sequence::type_id::create("seq");
    seq.mode = RANDOM_MIX;
    seq.start(env.agent.sequencer);

    #100ns; 
    
    `uvm_info("TEST", "=======================================", UVM_LOW)
    `uvm_info("TEST", "  END MASTER SEQUENCE", UVM_LOW)
    `uvm_info("TEST", "=======================================", UVM_LOW)
    
    phase.drop_objection(this);
  endtask

endclass