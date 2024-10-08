interface inf (input bit clk);
	import synchronous_fifo_pkg::*;

	logic resetn;
	bit w_en, r_en;
	bit   [FIFO_WIDTH-1:0] d_in;
	logic [FIFO_WIDTH-1:0] d_out;



endinterface 