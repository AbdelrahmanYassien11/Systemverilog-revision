
	covergroup d_in_cg(input bit [FIFO_WIDTH-1:0] position, ref bit [FIFO_WIDTH-1:0] vector);
		 pos: coverpoint (position & vector) !=0;
		 option.per_instance = 1;
	endgroup

class coverage;

	item item_h;
	d_in_cg d_in_bits[FIFO_WIDTH-1];

	mbx mbx2;	

	covergroup operation_cg();
	   	df: coverpoint item_h.operation_t {
	   		bins RESET_op 	= {RESET};
	   		bins WRITE_op 	= {WRITE};
	   		bins READ_op  	= {READ};
	   		bins RANDOM_op	= {RANDOM};
	   	}
	   	dt: coverpoint item_h.operation_t {
	   		bins RESET_TO_RESET = 	(RESET => RESET);
	   		bins RESET_TO_READ  =	(RESET => READ);
	   		bins RESET_TO_WRITE =	(RESET => WRITE);
	   		bins RESET_TO_RANDOM =	(RESET => RANDOM);

	   		bins READ_TO_RESET = (READ => RESET);
	   		bins READ_TO_READ  = (READ => READ);
	   		bins READ_TO_WRITE = (READ => WRITE);
	   		bins READ_TO_RANDOM = (READ => RANDOM);

	   		bins WRITE_TO_RESET = (WRITE => RESET);
	   		bins WRITE_TO_READ  = (WRITE => READ);
	   		bins WRITE_TO_WRITE = (WRITE => WRITE);
	   		bins WRITE_TO_RANDOM = (WRITE => RANDOM);

	   		bins RANDOM_TO_RESET = (RANDOM => RESET);
	   		bins RANDOM_TO_READ  = (RANDOM => READ);
	   		bins RANDOM_TO_WRITE = (RANDOM => WRITE);
	   		bins RANDOM_TO_RANDOM = (RANDOM => RANDOM);
	   	}
	endgroup : operation_cg

	function new ();
		item_h = new();
		operation_cg = new();
		foreach (d_in_bits[i]) d_in_bits[i] = new(1'b1<<i,item_h.d_in);
	endfunction

	task execute();
		run_cov();
	endtask

	task run_cov();
		forever begin
			mbx2.get(item_h);
			$display("COVVVVVVVVVVVVVVVVVVV");
			item_h.item2str();
			operation_cg.sample();
			foreach(d_in_bits[i]) begin
				d_in_bits[i].sample();
			end
		end
	endtask


endclass : coverage