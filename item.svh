class item;

	rand logic resetn;
	rand bit   w_en, r_en;
	rand bit   [FIFO_WIDTH-1:0] d_in;

	rand operation_e operation_t;

	static bit tests_concluded;

	constraint operation_t_constraint { operation_t dist {0:/1, 1:/30, 2:/30, 4:/50};
	}

	function void item2str ();
		$display("resetn: %0d, w_en: %0d, r_en: %0d, d_in: %0d",resetn, w_en, r_en, d_in);
	endfunction

endclass