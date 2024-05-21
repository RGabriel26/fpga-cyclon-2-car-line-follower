module count_ture(
	input tact,
	input reset,
	
	output reg [3:0] cifra_unitati,
	output reg [3:0] cifra_zeci
);

always @(posedge tact or posedge reset) begin
	if (reset) begin 
		cifra_unitati <= 4'b0000;
		cifra_zeci <= 4'b0000;
	end else begin
		if (cifra_unitati == 4'b1001) begin // 9 in decimal
			cifra_unitati <= 4'b0000;
			if (cifra_zeci == 4'b1001) begin // 9 in decimal
				cifra_zeci <= 4'b0000;
			end else begin
				cifra_zeci <= cifra_zeci + 4'b0001;
			end
		end else begin
			cifra_unitati <= cifra_unitati + 4'b0001;
		end
	end
end

endmodule
