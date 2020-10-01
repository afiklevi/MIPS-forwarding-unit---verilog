`include "defines.v"

module forwarding_unit (op_code,EX_MEM_RegWrite,MEM_WB_RegWrite,EX_MEM_RegisterRd,MEM_WB_RegisterRd,ID_EX_RegisterRs,ID_EX_RegisterRt,
			Forward_A,Forward_B,Forward_C);
						
  input EX_MEM_RegWrite, MEM_WB_RegWrite; // sel signal for RegWrite
  input [4:0] EX_MEM_RegisterRd, MEM_WB_RegisterRd, ID_EX_RegisterRs, ID_EX_RegisterRt;
  input [5:0] op_code;
  output reg [1:0] Forward_A, Forward_B, Forward_C;
  
  always @ (*) begin
	
	// itialization of the "forwarding enable" output signals to zero
	{Forward_A, Forward_B, Forward_C} <= 2'b00;
  
  	// --------------------------------------------------------------------------------------------------------

  
	// Specific treatment for R-type instructions (No need for C forwarding).
  
	if (op_code == `OP_ADD || op_code == `OP_SUB) begin
  
	if ((EX_MEM_RegWrite) && (EX_MEM_RegisterRd != 5'b00000) &&(EX_MEM_RegisterRd == ID_EX_RegisterRs))  Forward_A <= 2'b01;
	else if ((MEM_WB_RegWrite) && (MEM_WB_RegisterRd != 5'b00000)  && (ID_EX_RegisterRs != EX_MEM_RegisterRd) && (MEM_WB_RegisterRd == ID_EX_RegisterRs)) Forward_A <= 2'b10;
			
	if ((EX_MEM_RegWrite) && (EX_MEM_RegisterRd != 5'b00000) &&(EX_MEM_RegisterRd == ID_EX_RegisterRt)) Forward_B <= 2'b01;
	else if ((MEM_WB_RegWrite) && (MEM_WB_RegisterRd != 5'b00000) && (ID_EX_RegisterRt != EX_MEM_RegisterRd) && (MEM_WB_RegisterRd == ID_EX_RegisterRt)) Forward_B <= 2'b10;
	
	end
	
	// End of R-type forwarding conditions.

	// --------------------------------------------------------------------------------------------------------
	
	// Different treatment for I-type instructions (No need for B or C forwarding, 
	// because we want to take the IM), excluding SW.
	if (op_code == `OP_ADDI || op_code == `OP_SUBI || op_code == `OP_LW) begin
	
	if ((EX_MEM_RegWrite) && (EX_MEM_RegisterRd != 5'b00000) &&(EX_MEM_RegisterRd == ID_EX_RegisterRs))  Forward_A <= 2'b01;
	else if ((MEM_WB_RegWrite) && (MEM_WB_RegisterRd != 5'b00000)  && (ID_EX_RegisterRs != EX_MEM_RegisterRd) && (MEM_WB_RegisterRd == ID_EX_RegisterRs)) Forward_A <= 2'b10;
	
	end
	// End of I-type forwarding conditions.
	
	// --------------------------------------------------------------------------------------------------------
	
	// SW instruction treatment.
	if (op_code == `OP_SW) begin
	
	if ((EX_MEM_RegWrite) &&  (EX_MEM_RegisterRd != 5'b00000)&& (EX_MEM_RegisterRd == ID_EX_RegisterRt)) Forward_C <= 2'b01;
	else if ((MEM_WB_RegWrite) && (MEM_WB_RegisterRd != 5'b00000)&&  (ID_EX_RegisterRt != EX_MEM_RegisterRd) &&(MEM_WB_RegisterRd == ID_EX_RegisterRt))  Forward_C <= 2'b10;
	if ((MEM_WB_RegWrite) && (MEM_WB_RegisterRd != 5'b00000)  && (ID_EX_RegisterRs != EX_MEM_RegisterRd) && (MEM_WB_RegisterRd == ID_EX_RegisterRs)) Forward_A <= 2'b10;

	
	
	end
	
end
		
endmodule