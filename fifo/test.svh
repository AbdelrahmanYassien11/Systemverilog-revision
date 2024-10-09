class test;

	item item_h;
	int test_number;

	virtual inf f_if;
	event finished_test;
	event finished_sending_transaction;


	mbx mbx1;
	mbx mbx2;

	function void get_inf(virtual inf f_if);
		this.f_if = f_if;
	endfunction 

	function new();
		mbx1 = new();
		mbx2 = new();
		item_h = new();
	endfunction

	task run_test();
		reset_test();
		wait(finished_test.triggered);
		test_number = $urandom_range(100, 150);
		for(int i = 0; i <= test_number; i++) begin
			test_decider();
			@(finished_test);
		end
		item::tests_concluded = 1;
	endtask : run_test

	task execute(virtual inf f_if);
		get_inf(f_if);
		run_test();
	endtask : execute

	task test_decider();
		assert(item_h.randomize());
		$display("OPERATION_T = %p",item_h.operation_t);
		if(item_h.operation_t == RESET) begin
			reset_test();
		end
		else if(item_h.operation_t == WRITE) begin
			write_test();
		end
		else if(item_h.operation_t == READ) begin
			read_test();
		end
		else if(item_h.operation_t == RANDOM) begin
			random_test();
		end
	endtask

	task read_test ();
				mbx1.put(item_h);
		mbx2.put(item_h);
		item_h.item2str();
		f_if.resetn <= item_h.resetn;
		f_if.w_en 	<= item_h.w_en;
		f_if.r_en 	<= item_h.r_en;
		f_if.d_in 	<= item_h.d_in;
		//$display("time: %0t FINISHED SENDING READ TRANSACTION", $time());

		-> finished_sending_transaction;
	endtask

	task write_test ();
		mbx1.put(item_h);
		mbx2.put(item_h);
		item_h.item2str();
		f_if.resetn <= item_h.resetn;
		f_if.w_en 	<= item_h.w_en;
		f_if.r_en 	<= item_h.r_en;
		f_if.d_in 	<= item_h.d_in;
		//$display("time: %0t FINISHED SENDING WRITE TRANSACTION", $time());

		-> finished_sending_transaction;
	endtask


	task reset_test ();
				mbx1.put(item_h);
		mbx2.put(item_h);
		item_h.item2str();
		f_if.resetn <= item_h.resetn;
		f_if.w_en 	<= item_h.w_en;
		f_if.r_en 	<= item_h.r_en;
		f_if.d_in 	<= item_h.d_in;
		//$display("time: %0t FINISHED SENDING RESET TRANSACTION", $time());

		-> finished_sending_transaction;
	endtask


	task random_test ();
				mbx1.put(item_h);
		mbx2.put(item_h);
		item_h.item2str();
		f_if.resetn <= item_h.resetn;
		f_if.w_en 	<= item_h.w_en;
		f_if.r_en 	<= item_h.r_en;
		f_if.d_in 	<= item_h.d_in;
		//$display("time: %0t FINISHED SENDING RANDOM TRANSACTION", $time());

		-> finished_sending_transaction;
	endtask

endclass : test