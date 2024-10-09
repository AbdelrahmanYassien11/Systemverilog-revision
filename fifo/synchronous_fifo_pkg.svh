package synchronous_fifo_pkg;

	parameter FIFO_WIDTH = 16, NO_OF_ELEMENTS = 16, FIFO_DEPTH = $clog2(NO_OF_ELEMENTS-1);

	typedef enum {RESET, WRITE, READ, RANDOM} operation_e;



	`include "item.svh"
	typedef mailbox #(item) mbx;
	`include "test.svh"
	`include "scoreboard.svh"
	`include "coverage.svh"



endpackage : synchronous_fifo_pkg


