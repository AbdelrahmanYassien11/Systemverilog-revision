module fifo_tb();

	import synchronous_fifo_pkg::*;

	bit clk;
	always #5 clk = ~clk;

	inf f_if(clk);
	virtual inf my_vif;

	test test_h;
	scoreboard scoreboard_h;
	coverage coverage_h;

	mailbox #(item) mbx1;

synchronous_fifo fifo1(
		.clk(clk),
		.resetn(f_if.resetn),
		.w_en(f_if.w_en),
		.r_en(f_if.r_en),
		.d_in(f_if.d_in),
		.d_out(f_if.d_out)
	);

	initial begin
		test_h 		 = new();
		scoreboard_h = new();
		coverage_h 	 = new();

		my_vif = f_if;

		test_h.finished_test = scoreboard_h.finished_test;
		test_h.finished_sending_transaction = scoreboard_h.finished_sending_transaction;
		test_h.mbx1 = scoreboard_h.mbx1;


		fork
			test_h.execute(my_vif);
			scoreboard_h.execute(my_vif);
			// coverage_h.execute();
		join

		$stop;
	end

endmodule : fifo_tb
