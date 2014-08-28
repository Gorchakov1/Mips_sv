module hazard(
  input               clk_i,
  input               rst,
  input               haz_i,

  input        [15:0] cnt_i,
  input        [15:0] cnt_jmp_i,

  output logic [15:0] cnt_o
);

always_ff@ ( posedge clk_i or posedge rst )
  begin
    if( rst )
      cnt_o = 0;
    else
      begin
        if( cnt_jmp_i!=0 )
          begin
            cnt_o = cnt_jmp_i;
          end
        else
          begin
            if( cnt_i==cnt_o && haz_i!=1 )
              begin
 	        cnt_o = 0;
              end 
            else
              begin
	        cnt_o = cnt_i;
              end
	  end
      end 
  end
endmodule
