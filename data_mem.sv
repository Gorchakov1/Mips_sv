`include"my_struct"
module data_mem(
 input                        clk_i,
 input                        rst,
 
 input  [15:0]                data_wr_i,
 input  signal_in1            in1_i,
 
 input                        ena_wr_i,
 input  signal_offset_reg_mem offset_reg_i,
 input  signal_off_mem        off_wr_mem_i,
 
 output signal_mem_wr_reg     mem_wr_reg_o,
 
 integer d_out
);
 logic [15:0] ram [31:0];
initial
 begin
   #0.0
   begin
     $readmemb ("data.txt",ram);
   end
 #500000.0
   begin 
     d_out=$fopen("data_out.txt","w");
     $fwrite(d_out, "%p\n",ram);
     $fclose(d_out);
   end
 end

always @ (posedge clk_i)
 begin
   if( ena_wr_i && ( off_wr_mem_i.ena==0 ) )
     ram[ in1_i.adr_m[4:0] ] <= data_wr_i;
   else
     if( off_wr_mem_i.ena && ena_wr_i )
       ram[ off_wr_mem_i.adr[4:0] ] <= data_wr_i;
 end


always_comb
 begin 
   if( offset_reg_i.ena && in1_i.ena )
     begin
       mem_wr_reg_o.data = '0;
       mem_wr_reg_o.ena  = '0;
       mem_wr_reg_o.adr  = '0;
     end
   else
     begin
       if( ( offset_reg_i.ena==0 ) && in1_i.ena )
         begin
           mem_wr_reg_o.data = ( in1_i.ena == 0 )? 16'b0 : ram[in1_i.adr_m[4:0]];
           mem_wr_reg_o.adr  = in1_i.adr_r;
           mem_wr_reg_o.ena  = 1'b1;
         end
       else
         begin 
           if( offset_reg_i.ena && ( in1_i.ena==0 ) )
             begin
               mem_wr_reg_o.data = ( offset_reg_i.ena==0)? 16'b0 : ram[offset_reg_i.adr[4:0]];
               mem_wr_reg_o.adr  = in1_i.adr_r;
               mem_wr_reg_o.ena  = '1;
             end
           else
             begin
               mem_wr_reg_o.data = '0;
               mem_wr_reg_o.ena  = '0;
               mem_wr_reg_o.adr  = '0;
             end
         end
     end
 end



endmodule 
