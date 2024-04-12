module Logica_miscare(
    input senzor_1, 
    input senzor_2,
    input senzor_3,
    input senzor_4,
    input senzor_5, 
    
    output reg [1:0] directie_driverA, //responsabil pentru sensul motoarelor driverului A (din dreapta)
    output reg [1:0] directie_driverB, //responsabil pentru sensul motoarelor driverului B (din stanga)
    
    output reg semnal_dreapta,
    output reg semnal_stanga
);

//variabile locale
reg dreapta;
reg stanga;

initial begin 
	dreapta = 0;
	stanga = 0;
	directie_driverA = 2'b10;
	directie_driverB = 2'b10;
end 
	
//logica directiei
always @(senzor_2 or senzor_3 or senzor_4) begin
	//conditie ca senzorul se afla pe traseul corect
	if(senzor_3 == 1) begin
		//creaza conditie de salvare in reg dreapta/stanga a ultimei activari a senzorului
		//si crearea conditie de resetare a registrilor dreapta si stanga pentru cazul in care senzorul_3 iese de pe circuit
		
		//conditie de rotire spre dreapta
		if(senzor_2 == 1) begin
			directie_driverA = 2'b01;
			dreapta = 1;
		end
		//resetarea directiei pentru driverul A
		else begin 
			directie_driverA = 2'b10;
			dreapta = 0;
		end
		
		//conditie de mers spre stanga
		if(senzor_4 == 1) begin
			directie_driverB = 2'b01;
			stanga = 1;
		end
		//resetarea directiei pentru driverul B
		else begin 
			directie_driverB = 2'b10;
			stanga = 0; 
		end
	end
	else begin
	//logica de cautat traseul
		//cautare spre dreapta in functie de ultima directie cautata
		if(dreapta == 1 | stanga == 1) begin
			if(dreapta == 1) begin 
			directie_driverA = 2'b01;
			directie_driverB = 2'b10;
			end
			if(stanga == 1) begin
				directie_driverA = 2'b10;
				directie_driverB = 2'b01;
			end
			//resetarea registrilor se realizeaza in conditia ca senzorul_1 sa fie in 1 logic
			//trebuie TESTAT
		end
		//logica de rotire pentru cautarea traseului 
		else begin
		//masina va merge inapoi
			directie_driverA = 2'b01;
			directie_driverB = 2'b01;
		end
	end
end

//logica semnalizarii
always @(senzor_1 or senzor_5) begin
	
end

endmodule