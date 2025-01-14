class scoreboard;

	item item_h;
	virtual inf f_if;

	bit [FIFO_WIDTH-1:0] data_written [$];
	bit [FIFO_WIDTH-1:0] d_out_expected;
	bit full_expected, empty_expected;


	event finished_test;
	event finished_sending_transaction;

	bit tests_concluded;


	bit [FIFO_DEPTH:0] w_ptr, r_ptr;

	mbx mbx1;

	function new();
		item_h = new();
	endfunction

	function void get_inf(virtual inf f_if);
		this.f_if = f_if;
	endfunction 

	task execute(virtual inf f_if);
		get_inf(f_if);
		run_scoreboard();
	endtask : execute

	task run_scoreboard();
		forever begin
			if(!item::tests_concluded)begin
				wait(finished_sending_transaction.triggered);
				mbx1.get(item_h);
				fifo_write_read();
				@(negedge f_if.clk);
				check_result();
				-> finished_test;
			end
			else begin
				$display("TESTS_CONCLUDED");
				$finish();
			end
		end
	endtask : run_scoreboard;


	task fifo_write_read(/*input bit [FIFO_WIDTH-1:0] d_in*/);
		if(~item_h.resetn)begin
			d_out_expected = 0;
			data_written.delete();
			flags();
		end
		else if (item_h.w_en & (!full_expected)) begin
			$display("ENTERING WRITE");
			data_written.push_back(item_h.d_in);
			w_ptr = w_ptr +1;
			flags();
		end
		else if(item_h.r_en & (!empty_expected)) begin
			$display("ENTERING READ");
			d_out_expected = data_written.pop_front();
			r_ptr = r_ptr +1;
			flags();
		end
	endtask : fifo_write_read

	task flags();
		if(w_ptr == r_ptr) begin
			empty_expected = 1;
			full_expected = 0; //maybe obsolete
		end
		else if( (w_ptr[FIFO_DEPTH] == !r_ptr[FIFO_DEPTH]) & (w_ptr[FIFO_DEPTH-1:0] == r_ptr[FIFO_DEPTH-1:0]) ) begin
			full_expected = 1;
			empty_expected = 0; //maybe obsolete
		end
		else begin
			full_expected = 0;
			empty_expected = 0;
		end
	endtask 

	function void check_result();
		if(d_out_expected !== f_if.d_out) begin
			$display("TIME: %0t SCOREBOARD FAIL d_out_expected = %0d & d_out = %0d", $time(), d_out_expected, f_if.d_out);
		end
		else begin
			$display("TIME: %0t SCOREBOARD PASS", $time());
		end
	endfunction : check_result

endclass : scoreboard