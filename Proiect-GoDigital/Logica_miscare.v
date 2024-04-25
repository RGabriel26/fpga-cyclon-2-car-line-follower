module Logica_miscare(
	    /* 
	VERSIUNEA: 
	-SCHIMBAREA DIRECTIEI DE DEPLASARE SE REALIZEAZA IN 2 MODURI
		- DACA SENZOR_3 ESTE PE LINIE ATUNCI SE OPRESC ROTILE DIN INTERIORUL CURBEI
		- DACA SENZOR_3 ESTE IN AFARA LINIEI ATUNCI ROTILE DIN INTERIORUL CURBEI SE INVART INVERS
	
	########### semnalele de input ############# 
	
	 >>>> LOGICA SEMNALELOR DE LA IESIREA SENZORILOR ESTE INVERSATA <<<<
	 
	senzor_1 / senzor_5 -> folosit pentru a detecta linia de semnalizare de curba spre dreapta sau stanga
						   sau pentru a detecta un linia de finish a circuitului (cand ambii senzori sunt in 1 logic)
	
	senzor_3 -> senzorul ce ar trebui mereu sa fie pe linia neagra a circuitului
				cand acesta detecteaza culoarea neagra, a liniei circuitului, are la iesire 1 logic
				asta inseamna ca masina se afla pe directia corecta
				
	senzor_2 / senzor_4 -> pentru detectarea neregularitatilor de directie a masinii
						   daca unul din ei detecteaza linia neagra a circuitului, astfel vor scoate semnal la iesire de 1 logic
						   inseamna ca masina are o directie gresita si trebuie corectata
					
	circuit -> semnal provenit de la alt bloc logic care va determina tipul de circuit pe care urmeaza sa se deplaseze masinuta
	
	########### semnalele de output ############# 		
			   
	directie_driverA -> iesire pentru stabilirea sensurilor motoarelor aferente driverului A, semnal de 2 biti
	directie_driverB -> iesire pentru stabilirea sensurilor motoarelor aferente driverului B, semnal de 2 biti
	semnal_dreapta -> semnal pentru semnalizarea spre dreapta
	semnal_stanga -> semnla pentru semnalizarea spre stanga
	stop -> semnal de semnalizare a franii
	count_ture -> semnal pe 8 biti pentru a afisarea numarului de ture parcurse
	factor_dc_driverA -> numar pe 12 biti pentru compararea in comparator pentru stabilirea factorului de umplere pentru driverul A
	factor_dc_driverA -> numar pe 12 biti pentru compararea in comparator pentru stabilirea factorului de umplere pentru driverul B
	
	########### variabile locale #############
	
	dreapta / stanga -> sunt registrii de 1 bit care memoreaza ultima activare a senzorului de dreapta sau de stanga 
						in cazul in care senzor_3 este pe traseu
	
	
	*/
    input senzor_1, 
    input senzor_2,
    input senzor_3,
    input senzor_4,
    input senzor_5, 
    input [1:0] circuit,
    
    output reg [1:0] directie_driverA,
    output reg [1:0] directie_driverB,
    
    output reg semnal_dreapta,
    output reg semnal_stanga,
    output reg stop, 
    output reg [7:0] count_ture,
    
    output reg [11:0] factor_dc_driverA,
    output reg [11:0] factor_dc_driverB 
);
//variabile locale
//pentru memorarea temporara a curbei in cazul in care senzor_3 iese de pe circuit
reg dreapta;
reg stanga;

initial begin 
	dreapta = 0;
	stanga = 0;
	semnal_dreapta = 0;
	semnal_stanga = 0;
	stop = 0;
	count_ture = 0;
	//initializare cu starea de mers inainte
	directie_driverA = 2'b10;
	directie_driverB = 2'b10;
	//initializarea factorului de comparatie cu numarul obtinut din numarator
	//initializare cu 999 asta inseamna starea maxima de comparat in comparator ceea ce ofera un semnal PWM aproape de 100% ca duty cycle
	factor_dc_driverA = 12'h999; // procentajul de duty cycle a semnalului PWM a driverului A
	factor_dc_driverB = 12'h999; // procentajul de duty cycle a semnalului PWM a driverului B
	
end 

//SEMNALUL DE 1 LOGIC AL INTRARILOR APARE ATUNCI CAND SENZORUL DETECTEAZA NEGRU
//LEDUL DE CONTROL AL ACESTUIA ESTE STINS
//CRED... TREBUIE TESTAT IAR .. 

//FOLOSIREA TRIBUIRILOR NEBLOCANTE (<=) CRED CA POATE GENERA PROBLEME IN RESETAREA REGISTRILOR
	
//logica directiei
always @* begin
	//conditie ca senzorul se afla pe traseul corect
	if(senzor_3 == 1) begin
		//creaza conditie de salvare in reg dreapta/stanga a ultimei activari a senzorului
		//si crearea conditie de resetare a registrilor dreapta si stanga pentru cazul in care senzorul_3 iese de pe circuit
		if({senzor_2, senzor_4} != 2'b11) begin  //tratarea cazului cand senzorii nu sunt simultan in 1 logic
			directie_driverA = (senzor_2 == 1) ? 2'b00 : 2'b10;
			directie_driverB = (senzor_4 == 1) ? 2'b00 : 2'b10;
			
			dreapta = (senzor_2 == 1) ? 1 : 0;
			stanga = (senzor_4 == 1) ? 1: 0;
		end else begin //tratarea cazului cand senzorii sunt simultan in 1 logic
			//masina va continua sa mearga in fata
			directie_driverA = 2'b10;
			directie_driverB = 2'b10;
		end
	end
	else begin // cazul cand senzor_3 iese de pe circuit(0 logic)
		//cautare spre dreapta in functie de ultima directie cautata
		if(dreapta == 1 | stanga == 1) begin
			//posibil ca sensutile sa trebuiasca puse invers
			directie_driverA = (dreapta == 1) ? 2'b01 : 2'b10;
			directie_driverB = (stanga == 1) ? 2'b01 : 2'b10;
			//resetarea registrilor se realizeaza in conditia ca senzorul_1 sa fie in 1 logic
			//trebuie TESTAT
		end else begin
			if({senzor_2, senzor_4} != 2'b11) begin  //tratarea cazului cand senzorii nu sunt simultan in 1 logic
				directie_driverA = (senzor_2 == 1) ? 2'b01 : 2'b10;
				directie_driverB = (senzor_4 == 1) ? 2'b01 : 2'b10;
				
				dreapta = (senzor_2 == 1) ? 1 : 0;
				stanga = (senzor_4 == 1) ? 1: 0;
			end else begin //tratarea cazului cand senzorii sunt simultan in 1 logic
				//masina va continua sa mearga in fata
				directie_driverA = 2'b10;
				directie_driverB = 2'b10;
			end
		end
	end
	//LOGICA COMPORTAMENTALA PE DIFERITE CIRCUTE
	if (senzor_1 == 1 & senzor_5 == 1) begin 
		count_ture = count_ture + 1;
		//conditie de circuit pentru circuitul 1 (proba linie dreapta)
		if (circuit == 2'b01 & count_ture == 1) begin 
			directie_driverA = 2'b00;
			directie_driverB = 2'b00;
		end
		//conditie de circuit pentru circuitul 2 (proba curbe)
		if (circuit == 2'b10 & count_ture == 10) begin 
			//in acest caz, cand masina face 10 cicluri pe circuit, se va opri
			directie_driverA = 2'b00;
			directie_driverB = 2'b00;
		end
		//conditie de circuit pentru circuitul 3 (proba anduranta)
		//conditia consta in numararea turelor de circuit pana la terminarea bateriilor 
		//instructiune ce se realizeaza deja mai sus 
		
		//conditie de resetare a numarului de cicluri
		if (circuit == 2'b00) begin
			count_ture = 0;
		end
	end
	
	//OUTPUT SEMNALA DE INFORMARE
	//scoaterea numarului de ture realizate de masina
	//acesta va fi modificat si scos la iesire pe parcursul parcurgerii logicii de mai sus
	//numarul turelor de circuit contorizate se iau din output count_ture
	//care este un sir de 8 biti, capabil pentru numere pana in 255
	
	//scoaterea unor semnale destinate semnalizarii exterioare
	semnal_dreapta = senzor_1;
	semnal_stanga = senzor_5;
	
	//semnalul de stop
	//cand masina nu mai este centrata pe linia neagra => adica cand senzor_3 nu mai este pe traseu
	// AR TREBUI SA SE TRIMITA SEMNAL DE STOP MEREU CAND MASINA SE REPOZITIONEAZA ??? 
	stop = ~senzor_3;
end

endmodule	