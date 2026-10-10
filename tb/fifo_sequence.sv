typedef enum {WRITE_ONLY, READ_ONLY, RANDOM_MIX} seq_mode_e;

class fifo_sequence extends uvm_sequence #(fifo_transaction);
    `uvm_object_utils(fifo_sequence)

    seq_mode_e mode = RANDOM_MIX;
    int loop_count = 20; 

    function new(string name = "fifo_sequence");
        super.new(name);
    endfunction

    virtual task body();
        case (mode)
            WRITE_ONLY: begin
                `uvm_info("SEQ", "Running sequence: WRITE ONLY (Fill FIFO)", UVM_LOW)
                repeat (loop_count) begin
                    req = fifo_transaction::type_id::create("req");
                    start_item(req);
                    assert(req.randomize() with { wr_en == 1'b1; rd_en == 1'b0; });
                    finish_item(req);
                end
            end

            READ_ONLY: begin
                `uvm_info("SEQ", "Running sequence: READ ONLY (Empty FIFO)", UVM_LOW)
                repeat (loop_count) begin
                    req = fifo_transaction::type_id::create("req");
                    start_item(req);
                    assert(req.randomize() with { wr_en == 1'b0; rd_en == 1'b1; });
                    finish_item(req);
                end
            end

            RANDOM_MIX: begin
                `uvm_info("SEQ", "Running sequence: RANDOM MIX (Coverage Test)", UVM_LOW)
                repeat (loop_count) begin
                    req = fifo_transaction::type_id::create("req");
                    start_item(req);
                    assert(req.randomize() with { !(wr_en == 1'b0 && rd_en == 1'b0); });
                    finish_item(req);
                end
            end
            
            default: begin
                `uvm_error("SEQ", "Invalid sequence mode!")
            end
        endcase
    endtask
endclass