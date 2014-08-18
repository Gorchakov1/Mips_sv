`include "my_def"
`include "my_struct"
module id_mod (
 input                             clk_i,
 input                             rst,

 input        [15:0]               instr_i,
 output logic                      haz_o,
 
 output logic [7:0]                alu_o,
 output logic [11:0]               cnt_o,


 output       signal_adr_regt      adr_regt_o,

 output       signal_reg_wr_mem    reg_wr_mem_o,
 output       signal_off_wr_mem    off_wr_mem_o,
 output logic                      ena_w_mem_o,

 output       signal_offset_id_reg offset_id_o,
 output       signal_in1           in1_o
);
 logic        [15:0]               instr;


always @ (posedge clk_i)
 begin
   case( instr[15:12] )
     `OP_IN : 
       begin//in
         if( instr[8:5]==0 )
           begin
             off_wr_mem_o.adr   <= 0;
             off_wr_mem_o.ena   <= 0;
             offset_id_o.adr_rm <= 0;
             offset_id_o.ena    <= 0;
             in1_o.adr_m        <= instr[4:0];
             cnt_o              <= 0;
             in1_o.ena          <= 1;
             reg_wr_mem_o.ena   <= 0;
             in1_o.adr_r        <= instr[11:9]+4'b0;
           end
         else
           begin
             off_wr_mem_o.adr   <= 0;
             off_wr_mem_o.ena   <= 0;
             in1_o.adr_r        <= instr[11:9];
             in1_o.ena          <= 0;
             in1_o.adr_m        <= 0;
             offset_id_o.adr_rm <= instr[8:5];
             offset_id_o.ena    <= 1;
           end
       end
     `OP_WR : 
       begin//wr
         if( instr[7:5]==0 )
           begin
             offset_id_o.adr_rm <= 0;
             offset_id_o.ena    <= 0;
             cnt_o              <= 0;
             reg_wr_mem_o.ena   <= 1;
             ena_w_mem_o        <= 1;
             reg_wr_mem_o.adr   <= instr[11:8];
  	     adr_regt_o.a1      <= 0;
             adr_regt_o.a2      <= 0;
             in1_o.adr_m        <= instr[4:0];
             off_wr_mem_o.adr   <= 0;
             off_wr_mem_o.ena   <= 0;
           end
         else
           begin
             offset_id_o.adr_rm <= 0;
             offset_id_o.ena    <= 0;
             off_wr_mem_o.adr   <= instr[7:5];
             off_wr_mem_o.ena   <= 1;
             cnt_o              <= 0;
             reg_wr_mem_o.ena   <= 1;
             ena_w_mem_o        <= 1;
	     reg_wr_mem_o.adr   <= instr[11:8];
	     adr_regt_o.a1      <= 0;
             adr_regt_o.a2      <= 0;
             in1_o.adr_m        <= 0;
           end
       end
     `OP_JMP : 
       begin//in
         off_wr_mem_o.adr   <= 0;
         off_wr_mem_o.ena   <= 0;
         offset_id_o.adr_rm <= 0;
         offset_id_o.ena    <= 0;
         in1_o.adr_m        <= 0;
         in1_o.ena          <= 0;
         reg_wr_mem_o.ena   <= 0;
         in1_o.adr_r        <= 0;
         cnt_o              <= instr[11:0];
       end
     `OP_JN : 
       begin//in
         off_wr_mem_o.adr   <= 0;
         off_wr_mem_o.ena   <= 0;
         offset_id_o.adr_rm <= 0;
         offset_id_o.ena    <= 0;
         in1_o.adr_m        <= 0;
         in1_o.ena          <= 0;
         reg_wr_mem_o.ena   <= 0;
         in1_o.adr_r        <= 0;
         cnt_o              <= instr[11:0];
       end
     `OP_JR : 
       begin//in
         off_wr_mem_o.adr   <= 0;
         off_wr_mem_o.ena   <= 0;
         offset_id_o.adr_rm <= 0;
         offset_id_o.ena    <= 0;
         in1_o.adr_m        <= 0;
         in1_o.ena          <= 0;
         reg_wr_mem_o.ena   <= 0;
         in1_o.adr_r        <= 0;
         cnt_o              <= instr[11:0];
       end
     default:	
       begin		
         if( instr[15:11]!=0 ) //N??»?°?? N?N??µ????N 
	   begin
	     off_wr_mem_o.adr   <= 0;
             off_wr_mem_o.ena   <= 0;
	     offset_id_o.adr_rm <= 0;
             offset_id_o.ena    <= 0;
	     cnt_o              <= 0;
             reg_wr_mem_o.ena   <= 0;
             adr_regt_o.ena     <= 1;
             adr_regt_o.a1      <= instr[7:4];
             adr_regt_o.a2      <= instr[3:0];
             in1_o.adr_m        <= 0;
             in1_o.ena          <= 0;
             in1_o.adr_r        <= 0;
             ena_w_mem_o        <= 0;
             reg_wr_mem_o.adr   <= 0;
           end
        else
          begin
            off_wr_mem_o.adr   <= 0;
            off_wr_mem_o.ena   <= 0;
            offset_id_o.adr_rm <= 0;
            offset_id_o.ena    <= 0;
            cnt_o              <= 0;
            adr_regt_o.ena     <= 0; 
            adr_regt_o.a1      <= instr[7:4];
            adr_regt_o.a2      <= instr[3:0];
            in1_o.adr_m        <= 0;
            in1_o.ena          <= 0;
            in1_o.adr_r        <= 0;
            ena_w_mem_o        <= 0;
            reg_wr_mem_o.ena   <= 0;
            reg_wr_mem_o.adr   <= 0;
          end
       end
    endcase
  end



assign instr = instr_i; // op_cod adr_regc adr_rega adr_regb
assign alu_o = instr[15:8];




always @ (posedge rst or posedge clk_i)
 begin
   if( rst )
     haz_o <= 0;
   else
     haz_o <= haz_o+1'b1;
 end

endmodule 


