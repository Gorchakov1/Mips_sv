module instrmem_mem(
input       [15:0] cnt_i,
output logic[15:0] instr_o);
logic       [15:0] instr [27:0];


initial
 begin
   #0.0
   $readmemb ("instr.txt",instr);
 end

assign instr_o = instr[cnt_i];


endmodule 
