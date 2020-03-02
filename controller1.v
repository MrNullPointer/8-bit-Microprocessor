// This is a controller file created by **Parikshit Dubey** and **Arva Kagdi** //
// Controller code displays all the states in which conroller is going to work  and which signals  will be on and off respectively //

module ControllerFSM (
input wire Z, C, CLK, CLB,
input wire [3:0]Opcode,
output reg LoadIR, IncPC, SelPC, LoadPC, LoadReg, LoadAcc,
output reg [1:0] SelAcc,
output reg [3:0] SelALU
);
	parameter clr= 2'b00, IRld = 2'b01, InsE =2'b10;       // parameterized value
	reg [1:0] presentstate;
	reg carry,zero;
	reg [1:0] nextstate;

always @(posedge CLK or negedge CLB)
begin
if(CLB ==1'b0)
	presentstate <= clr; 
else
	presentstate <= nextstate;
end

always @ (*) begin
 
// When the present state has high clear bit, accumalator, program counter and registers are cleared to 0 //
if(presentstate == clr)
   begin
         IncPC   <= 1'b0;
         SelPC   <= 1'b0;
         LoadReg <= 1'b0;
         LoadIR  <= 1'b0;
         LoadPC  <= 1'b0;
         LoadAcc <= 1'b0;
         SelAcc  <= 2'b00;         
         SelALU  <= 4'b0000; 
         nextstate = IRld;
   end

// If present state has interrupt control then LoadIR is active "1"//

else if(presentstate == IRld)
   begin
	LoadIR  <= 1'b1;
	SelALU  <= Opcode;
	SelAcc  <= 2'b00;
	LoadReg <= 1'b0;
	LoadAcc <= 1'b0;
	LoadPC  <= 1'b0;
	IncPC   <= 1'b0;
	SelPC   <= 1'b0;
	nextstate = InsE;
   end

// for opcode 0011 NOR function takes place //
else if(presentstate == InsE)
   begin
	LoadIR <= 1'b0;
	 case (Opcode)
4'b0011 : begin
           SelALU  <= Opcode;
           SelAcc  <= 2'b00;
           LoadReg <= 1'b0;
           LoadAcc <= 1'b1;
           LoadPC  <= 1'b0;
           IncPC   <= 1'b1;
           SelPC   <= 1'b1;
    end

// For opcode "0100" Register value is move to accumalator // 
4'b0100 : begin
           SelALU  <= Opcode;
           SelAcc  <= 2'b10;
           LoadReg <= 1'b0;
           LoadAcc <= 1'b1; 
           LoadPC  <= 1'b0;
           IncPC   <= 1'b1;
           SelPC   <= 1'b1;
          end
//For opcode "0001" ADD function takes place // 
4'b0001 : begin
           SelALU  <= Opcode;
           LoadReg <= 1'b0;
           SelAcc  <= 2'b00;
           LoadAcc <= 1'b1;
           LoadPC  <= 1'b0;
           SelPC   <= 1'b1;
           IncPC   <= 1'b1;
	   if(C==1'b1)carry = 1'b1;
	   else carry =1'b0;
	   if(Z==1'b1) zero = 1'b1;
	   else zero =1'b0;
          end
// For "0101" Accumalator data is  moved to register //
4'b0101 : begin
           SelALU  <= Opcode;
           SelAcc  <= 2'b10;
           LoadReg <= 1'b1;
           LoadAcc <= 1'b0;
           LoadPC  <= 1'b0;
           IncPC   <= 1'b1;
           SelPC   <= 1'b1;
          end
// HALT  //
4'b1111 : begin
             SelALU  <= Opcode;
             SelAcc  <= 2'b11;
             LoadReg <= 1'b0;
             LoadAcc <= 1'b0;      
             LoadPC  <= 1'b0;
             IncPC   <= 1'b1;
             SelPC   <= 1'b1;
           end 
// Jump if zero to register value //
4'b0110 : begin
           SelALU <= Opcode;
           if(zero==1'b1) 
   	    begin
  	       LoadPC  <= 1'b1;
               SelPC   <= 1'b1;
               SelAcc  <= 2'b10;
               LoadReg <= 1'b0;
  	       LoadAcc <= 1'b1;
               IncPC   <= 1'b0;
	    end
	   else 
	    begin
	       LoadPC  <= 1'b0;
	       IncPC   <= 1'b1;
	       SelPC   <= 1'b1;
	       SelAcc  <= 2'b10;
   	       LoadReg <= 1'b0;
	       LoadAcc <= 1'b1;        
      	    end
	   end
// Jump if zero to immediate //
4'b0111 : begin
	SelALU <= Opcode;           
	if(zero ==1'b1) 
	 begin
	   LoadPC  <= 1'b1;
	   SelPC   <= 1'b0;
	   SelAcc  <= 2'b11;
	   LoadReg <= 1'b0;
	   LoadAcc <= 1'b1;          
           IncPC   <= 1'b0;          
       	  end
	else 
	  begin
	   LoadPC  <= 1'b0;
	   IncPC   <= 1'b1;
	   SelPC   <= 1'b0;
	   SelAcc  <= 2'b11;
	   LoadReg <= 1'b0;
	   LoadAcc <= 1'b1;
	 end
	end
// Jump if carry to reg value //
4'b1000 : begin
	SelALU <= Opcode;      
	if(carry==1'b1)
	  begin 
	    LoadPC  <= 1'b1;
	    SelPC   <= 1'b1;
	    SelAcc  <= 2'b10;
	    LoadReg <= 1'b0;
	    LoadAcc <= 1'b1;
	    IncPC   <= 1'b0;           
	   end
	else
	   begin
	     SelAcc  <= 2'b10;
	     LoadReg <= 1'b0;
	     LoadAcc <= 1'b1;
	     LoadPC  <= 1'b0;
	     IncPC   <= 1'b1;
	     SelPC   <= 1'b1;
	    end
	end

// Jump if carry to immediate //
4'b1010 : begin
	SelALU <= Opcode;     
	if(carry==1'b1) 
	  begin
	    LoadPC  <= 1'b1;
	    SelPC   <= 1'b0;
	    SelAcc  <= 2'b11;
	    LoadReg <= 1'b0;
	    LoadAcc <= 1'b1;
	    IncPC   <= 1'b0;
	   end
	else
	  begin
	    LoadPC  <= 1'b0;
	    SelPC   <= 1'b0;
	    SelAcc  <= 2'b11;
	    LoadReg <= 1'b0;
	    LoadAcc <= 1'b1;          
	    IncPC   <= 1'b1; 
end
end

//Shift accumalator data to left //
 4'b1011 : begin
	    SelALU  <= Opcode;
	    SelAcc  <= 2'b00;
       	    LoadReg <= 1'b0;
	    LoadAcc <= 1'b1;           
	    LoadPC  <= 1'b0;
	    IncPC   <= 1'b1;
	    SelPC   <= 1'b1;
	   end

// Load immediate to Accumalator //
 4'b1101 : begin
            SelALU  <= Opcode;
            SelAcc  <= 2'b11;
            LoadReg <= 1'b0;
            LoadAcc <= 1'b1;
            LoadPC  <= 1'b0;
            SelPC   <= 1'b0;
            IncPC   <= 1'b1;
           end         
      
//NOP //  
 4'b0000 : begin
            SelALU   <= Opcode;
            SelAcc   <= 2'b11;
            LoadReg  <= 1'b0;
            LoadAcc  <= 1'b0;         
            LoadPC   <= 1'b0;
            IncPC    <= 1'b1;
            SelPC    <= 1'b1;
           end

//SUB //
4'b0010 : begin
           SelALU  <= Opcode;
           SelAcc  <= 2'b00;
           LoadReg <= 1'b0;
           LoadAcc <= 1'b1;
           LoadPC  <= 1'b0;
           SelPC   <= 1'b1;
           IncPC   <= 1'b1;
       	   if(C==1'b1)carry = 1'b1;
	   else carry = 1'b0;
	   if(Z==1'b1)zero = 1'b1;
	   else zero = 1'b0;
          end

// Shift accumulator data to right //
4'b1100 : begin
           SelALU  <= Opcode;
           SelAcc  <= 2'b00;
           LoadReg <= 1'b0;
           LoadAcc <= 1'b1;    
           LoadPC  <= 1'b0;
           IncPC   <= 1'b1;
           SelPC   <= 1'b1;
          end    
      
             
endcase
nextstate = IRld;
end
end
endmodule 