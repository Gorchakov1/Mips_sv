module counter (
input               clk_i,
input        [15:0] cnt_i,
input               rst,
input               haz_i,
output logic [15:0] cnt_o
);


always @ (posedge clk_i or posedge rst)
 begin
   if( rst )
     begin
       cnt_o <= 1;
     end
   else
     begin
       if( cnt_i!=0 )
         begin
           cnt_o <= cnt_i;
         end
      else
        begin
          cnt_o <= cnt_o+haz_i;
        end
     end
 end
endmodule 
