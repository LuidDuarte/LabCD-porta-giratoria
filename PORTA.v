module portagiratoria(SW, LEDR, LEDG, CLOCK_27);

input [0:0]CLOCK_27;
input [2:0]SW; // [0] Metal, [1] Pessoa saindo, [2] Pessoa entrando.

output [1:0]LEDG; // [1] Pode sair, [0] Pode entrar.
output [3:0]LEDR; // [3] Porta travada, [2] "Parulho", [1] Não pode sair, [0] Não pode entrar.

reg [2:0]ESTADO; // de 0 a 4.

parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100; 

// TRANSIÇÃO DE ESTADOS

initial ESTADO = A;
always @(posedge CLOCK_27[0])
begin
	case (ESTADO)
		A: if(SW[2] == 0 && SW[1] == 1) ESTADO <= B; 
			else if (SW == 3'b100) ESTADO <= C;
			else if(SW == 3'b101) ESTADO <= D; 
			else if (SW[2] == 1 && SW[1] == 1) ESTADO <= E; 
			else ESTADO <= A;
			
		B: if(SW[2] == 1) ESTADO <= E; 
			else if (SW[1] == 0) ESTADO <= A; 
			else ESTADO <= B;
			
		C: if(SW[1] == 1) ESTADO <= E; 
			else if (SW [0] == 1) ESTADO <= D; 
			else if (SW[2] == 0) ESTADO <= A; 
			else ESTADO <= C;
		
		D: if(SW[1] == 1) ESTADO <= E; 
			else if (SW[0] == 0) ESTADO <= C; 
			else if(SW[2] == 0) ESTADO <= A; 
			else ESTADO <= D;
			
		E: if(SW[2] == 0) ESTADO <= B;
			else if (SW [1] == 0 && SW[0] == 0) ESTADO <= C; 
			else if(SW[1] == 0 && SW[0] == 1) ESTADO <= D;
			else if(SW[2] == 0 && SW[1] == 0) ESTADO <= A;
			else ESTADO <= E;
	endcase
end

// GERAÇÃO DAS SAIDAS
assign LEDG[0] = (~ESTADO[2] && ESTADO[1] && ~ESTADO[0]); // ESTADO C PODE ENTRAR.
assign LEDG[1] = (~ESTADO[2] && ~ESTADO[1] && ESTADO[0]); // ESTADO B PODE SAIR.

assign LEDR[0] = ((~ESTADO[2] && ESTADO[0]) || (ESTADO[2] && ~ESTADO[1] && ~ESTADO[0])); // MAPA DE KARNAUGH. ESTADO B, D, E NÃO PODE ENTRAR.
assign LEDR[1] = ((~ESTADO[2] && ESTADO[1]) || (ESTADO[2] && ~ESTADO[1] && ~ESTADO[0])); // MAPA DE KARNAUGH. ESTADO C, D, E NÃO SAIR.

assign LEDR[2] = (~ESTADO[2] && ESTADO[1] && ESTADO[0]); //ESTADO D LIGA A BUZINA. 
assign LEDR[3] = ((~ESTADO[2] && ESTADO[1] && ESTADO[0]) || (ESTADO[2] && ~ESTADO[1] && ~ESTADO[0])); //D, E PORTA TRAVA.

endmodule 