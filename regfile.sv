`include "my_struct"
module regfile (
input                         clk_i,
input                         rst,
output [15:0]                 out_1r_o,
input   signal_reg_wr_mem     reg_wr_mem_i,
input   signal_wr_reg         wr_reg_i,
input   signal_adr_regt       adr_regt_i,
input   signal_offset_id_reg  offset_id_i,

output  signal_off_mem        off_wr_mem_o,
output  signal_offset_reg_mem offset_reg_o,

input   signal_off_wr_mem     off_wr_mem_i, 
output  signal_data           data_o
);

reg [7:0][15:0] regs;

assign out_1r_o         = ( reg_wr_mem_i.ena == 0)? 16'b0  : regs[reg_wr_mem_i.adr[2:0]];
assign off_wr_mem_o.adr = ( off_wr_mem_i.ena == 0)? 16'b0  : regs[off_wr_mem_i.adr[2:0]];
assign data_o.a         = ( adr_regt_i.ena == 0)? 16'b0    : regs[adr_regt_i.a1[2:0]];
assign data_o.b         = ( adr_regt_i.ena == 0)? 16'b0    : regs[adr_regt_i.a2[2:0]];
assign offset_reg_o.adr = (offset_id_i.ena == 0) ? 5'b0    : regs[offset_id_i.adr_rm[2:0]];







always_comb
 begin
   if( offset_id_i.ena )
     begin 
       offset_reg_o.ena=1'b1;
     end
   else
     begin
       offset_reg_o.ena=1'b0;
     end
 end

always_comb
 begin
   if( off_wr_mem_i.ena )
     begin
       off_wr_mem_o.ena=1'b1;
     end
   else
     begin
       off_wr_mem_o.ena=1'b0;
     end
 end



always @ (posedge clk_i or posedge rst)
 begin
   if( rst )
     begin
       regs[0] <= 16'b0000_0000_0000_0000;
       regs[1] <= 16'b0000_0000_0000_0000;
       regs[2] <= 16'b0000_0000_0000_0000;
       regs[3] <= 16'b0000_0000_0000_0000;
       regs[4] <= 16'b0000_0000_0000_0000;
       regs[5] <= 16'b0000_0000_0000_0000;
       regs[6] <= 16'b0000_0000_0000_0000;
       regs[7] <= 16'b0000_0000_0000_0000;
     end
   else
     begin
       if( wr_reg_i.ena )
         begin
           regs[wr_reg_i.adr[2:0]]<=wr_reg_i.data;
         end
     end
 end


endmodule 
