module intarziere_semnal(
    input semnal,
    input clk, // clk de 1Hz
    output reg semnal_out
);

reg [2:0] counter; // pentru a numara pâna la 4 (4 secunde)

initial begin 
    semnal_out = 1'b0; 
    counter = 3'b000;
end

always @(posedge clk or posedge semnal) begin
    if (semnal) begin
        counter <= 3'b000; // Reset counter daca semnal este activ
        semnal_out <= 1'b1; // Daca semnal este activ, semnal_out este activ
    end else begin
        if (counter < 3'b100) begin // Daca contorul nu a ajuns la 4
            counter <= counter + 3'b001;
            semnal_out <= 1'b1; // Mentine semnal_out activ în timpul numararii
        end else begin
            semnal_out <= 1'b0; // Dupa 4 secunde, semnal_out devine 0
        end
    end
end

endmodule
