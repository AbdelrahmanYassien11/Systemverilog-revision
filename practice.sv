module practice();

	bit clk;

	always begin
		#1 clk = ~clk;
	end

	int q [$];
	int y [$];
	logic [7:0] to_be_copied;
	logic [7:0] to_be_copied_in;
	int delay;
	initial begin
		to_be_copied <= '{default:1, 1:0, 2:0 };
		to_be_copied_in <= to_be_copied;
		#1step;
		foreach(to_be_copied[i])begin
				$display("to_be_copied_in: %0p before #1step",to_be_copied);
		end
		delay = 10;
		#(delay * 1ns);
		$display("time = %0t",$time());
		foreach(to_be_copied_in[i])begin
				$display("to_be_copied_in: %0p after #1step",to_be_copied_in);
		end
		repeat(10) q.push_back($urandom); //$random, $urandom_range(200,300), $random_range(-10,500)
		for(int i = 0; i < q.size ; i+=5)begin
			y = q[i+:5];
			$display("i = %0d",i);
		end
		#50
		$stop;
	end

endmodule 

// module practice1();

// 	bit clk;

// 	always begin
// 		#1 clk = ~clk;
// 	end

// 	string str;
// 	initial begin
// 		repeat(10) q.push_back($urandom); //$random, $urandom_range(200,300), $random_range(-10,500)
// 		for(int i = 0; i < q.size ; i+=5)begin
// 			y = q[i+:5];
// 			$display("i = %0d",i);
// 		end
// 		#50
// 		$finish;
// 	end

// endmodule 