class test;

	item item_h;
	int test_number;

	virtual inf f_if;
	event finished_test;
	event finished_sending_transaction;


	mailbox #(item)mbx1;

	function void get_inf(virtual inf f_if);
		this.f_if = f_if;
	endfunction 

	function new_cons();
		mbx1 = new();
		item_h = new();
	endfunction

	task run_test();
		reset_test();
		wait(finished_test.triggered);
		test_number = $urandom_range(25, 30);
		for(int i = 0; i <= test_number; i++) begin
			test_decider();
			@(finished_test);
		end
		item::tests_concluded = 1;
	endtask : run_test

	task execute(virtual inf f_if);
		new_cons();
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
		item_h.w_en = 0;
		item_h.r_en = 1;
		item_h.resetn = 1;
		mbx1.put(item_h);
		item_h.item2str();
		f_if.resetn <= item_h.resetn;
		f_if.w_en 	<= item_h.w_en;
		f_if.r_en 	<= item_h.r_en;
		f_if.d_in 	<= item_h.d_in;
		$display("time: %0t FINISHED SENDING READ TRANSACTION", $time());

		-> finished_sending_transaction;
	endtask

	task write_test ();
		item_h.w_en = 1;
		item_h.r_en = 0;
		item_h.resetn = 1;
		mbx1.put(item_h);
		item_h.item2str();
		f_if.resetn <= item_h.resetn;
		f_if.w_en 	<= item_h.w_en;
		f_if.r_en 	<= item_h.r_en;
		f_if.d_in 	<= item_h.d_in;
		$display("time: %0t FINISHED SENDING WRITE TRANSACTION", $time());

		-> finished_sending_transaction;
	endtask


	task reset_test ();
		item_h.resetn = 0;
		mbx1.put(item_h);
		item_h.item2str();
		f_if.resetn <= item_h.resetn;
		f_if.w_en 	<= item_h.w_en;
		f_if.r_en 	<= item_h.r_en;
		f_if.d_in 	<= item_h.d_in;
		$display("time: %0t FINISHED SENDING RESET TRANSACTION", $time());

		-> finished_sending_transaction;
	endtask


	task random_test ();
		mbx1.put(item_h);
		item_h.item2str();
		f_if.resetn <= item_h.resetn;
		f_if.w_en 	<= item_h.w_en;
		f_if.r_en 	<= item_h.r_en;
		f_if.d_in 	<= item_h.d_in;
		$display("time: %0t FINISHED SENDING RANDOM TRANSACTION", $time());

		-> finished_sending_transaction;
	endtask

endclass : test