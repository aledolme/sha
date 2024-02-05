module ByteToUInt #(parameter DATA_WIDTH = 64);
    input [7:0] x[7:0]; // 8-bit input array x
    output logic [DATA_WIDTH-1:0] r; // 64-bit output r

    always_comb begin
        r = 64'h0; // Initialize r to zero

        for (int i = 0; i < 8; i = i + 1) begin
            r = r | ((uint'(x[i]) << (i * 8))); // Bitwise OR and left shift
        end
    end
endmodule
