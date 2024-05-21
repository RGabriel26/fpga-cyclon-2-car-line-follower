module afisare_multiplexata(
	input semnal_stanga, semnal_dreapta, stop,
	input clock,
	input [3:0] cifra_zeci, cifra_unitati,
	
	output reg D1, D2, D3, D4,
	output reg a,b,c,d,e,f,g
);
//variabile
reg [3:0] digit_1, digit_2, digit_3, digit_4;
reg [1:0] generator_adresa;
reg [3:0] mux_out;

initial begin 
	mux_out = 4'b0000;
	digit_1 = 4'b0000;
	digit_2 = 4'b0000;
	digit_3 = 4'b0000;
	digit_4 = 4'b0000;
	generator_adresa = 4'b0000;
end

always @(posedge clock) begin 
	// facem numerele de input pentru decodificator
	if (stop) begin
		digit_1 = 4'b1000;
		digit_2 = 4'b1000;
		digit_3 = 4'b1000;
		digit_4 = 4'b1000;
	end else begin 
		if ({semnal_stanga, semnal_dreapta} == 2'b00) begin 
				digit_1 = 4'b1101;
				digit_2 = (cifra_zeci == 0) ? 4'b1101 : cifra_zeci;
				digit_3 = cifra_unitati;
				digit_4 = 4'b1101;
		end else begin
			if ({semnal_dreapta, semnal_stanga} != 2'b11) begin 
				if (semnal_stanga == 1) begin 
					digit_1 = 4'b1011; // 11
					digit_2 = 4'b1100;
					digit_3 = 4'b1100;
					digit_4 = 4'b1100;
				end
				if (semnal_dreapta == 1) begin 
					digit_1 = 4'b1100; 
					digit_2 = 4'b1100;
					digit_3 = 4'b1100;
					digit_4 = 4'b1010; // 10	
				end	
			end	 
		end
	end 
	
	//generator adresa
	generator_adresa = generator_adresa + 2'b01;
	
	case(generator_adresa)
		2'b00 : {D1, D2, D3, D4} = 4'b1000;
		2'b01 : {D1, D2, D3, D4} = 4'b0100;
		2'b10 : {D1, D2, D3, D4} = 4'b0010;
		2'b11 : {D1, D2, D3, D4} = 4'b0001;
	endcase
	
end

//multiplexoare
always @(generator_adresa) begin 
	case (generator_adresa)
		2'b00 : mux_out = digit_1;
		2'b01 : mux_out = digit_2;
		2'b10 : mux_out = digit_3;
		2'b11 : mux_out = digit_4;
	endcase
end

//decodificator adresa
always @(mux_out) begin 

	case(mux_out) 
		4'b0000: begin a=0; b=0; c=0; d=0; e=0; f=0; g=1; end
		4'b0001: begin a=1; b=0; c=0; d=1; e=1; f=1; g=1; end
		4'b0010: begin a=0; b=0; c=1; d=0; e=0; f=1; g=0; end
		4'b0011: begin a=0; b=0; c=0; d=0; e=1; f=1; g=0; end
		4'b0100: begin a=1; b=0; c=0; d=1; e=1; f=0; g=0; end
		4'b0101: begin a=0; b=1; c=0; d=0; e=1; f=0; g=0; end
		4'b0110: begin a=0; b=1; c=0; d=0; e=0; f=0; g=0; end
		4'b0111: begin a=0; b=0; c=0; d=1; e=1; f=1; g=1; end
		4'b1000: begin a=0; b=0; c=0; d=0; e=0; f=0; g=0; end
		4'b1001: begin a=0; b=0; c=0; d=0; e=1; f=0; g=0; end
		
		4'b1010: begin a=0; b=0; c=0; d=0; e=1; f=1; g=0; end
		4'b1011: begin a=0; b=1; c=1; d=0; e=0; f=0; g=0; end
		4'b1100: begin a=1; b=1; c=1; d=1; e=1; f=1; g=0; end
		4'b1101: begin a=1; b=1; c=1; d=1; e=1; f=1; g=1; end

	endcase
end

endmodule