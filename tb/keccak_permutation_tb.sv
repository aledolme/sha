`timescale 1ns / 1ps

module keccak_permutation_tb();


reg [4:0][4:0][63:0] round_in;
reg [7:0] round_constant_signal_out;
reg [4:0] round_number;
wire [4:0][4:0][63:0] round_out;
integer i;
integer j;
integer round;

// ------- CLK ------------------------------
//always #HP clk = ~clk;


// ------ TXT data --------------------------
reg [63:0] din [0:24];

initial begin
	//$readmemh("input_data.txt" , din);
	$readmemh("din_sha3.txt" , din);
end

reg [63:0] fout[0:24];


initial begin: INIT
	round_number = 4'h0;
end

initial begin: LOAD_DATA
	for(i=0; i<5; i=i+1) begin
		for(j=0; j<5; j=j+1) begin
        	round_in[i][j] = din[i*5+j];
        	#5;
		end
    end

	#5;
	for(round=0; round<23; round++) begin
		round_number = round_number +1;
		round_in = round_out;
		#5;
	end

end



// -- UUT ---------------------------------------------
keccak_round uut_keccak (round_in,
						 round_constant_signal_out,
				  		 round_out);

keccak_round_constants_gen uut_RC (round_number,
								   round_constant_signal_out);


endmodule

