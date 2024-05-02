module Selectie_proba(
	input buton, //buton care selecteaza tipul de traseu pentru proba x
		
	output reg [1:0] circuit,
	output reg led1,led2,led3 //outputuri pentru informarea exterioara a traseului selectat
	
	);
	
	initial begin 
		circuit = 2'b00;
	end
	
	always @(posedge buton) begin 
		//incrementarea variabilei circuit care va stoca tipul de circuit pe care masina se va deplasa
		//si resetarea acestui registru cand ce detecteaza alta apasare si valoarea din registru este maxima (3 binar)
		circuit = circuit + 2'b01;
		
		//informarea in exterior prin leduri a tipului de circuit 
		// led1 - aprins - proba linie dreapta
		// led2 - aprins - proba curbe
		// led3 - aprins - proba anduranta
		// TOATE ledurie - stins - masina inactiva
		
		// dupa selectia unui circuit, se vor contoriza 5 secunde dupa care se va trimite comanda de MISCARE pentru masina 
		case(circuit)
			2'b00: begin led1=0; led2=0; led3=0; end
			2'b01: begin led1=1; led2=0; led3=0; end
			2'b10: begin led1=0; led2=1; led3=0; end
			2'b11: begin led1=0; led2=0; led3=1; end
		endcase
	end
endmodule