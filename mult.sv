`include "my_struct";
module mult( 
  input  signal_mem_wr_reg mem_wr_reg_i,
  input  signal_alu_wr_reg alu_wr_reg_i,
  output signal_wr_reg     wr_reg_o
);

always_comb 
  begin
    if( mem_wr_reg_i.ena && alu_wr_reg_i.ena )
      begin
        wr_reg_o.ena  = 1'b0;
        wr_reg_o.adr  = 3'b0;
        wr_reg_o.data = 16'b0;
      end
    else
      begin
        if( mem_wr_reg_i.ena && ( alu_wr_reg_i.ena==0 ) )
          begin
	    wr_reg_o.adr  = mem_wr_reg_i.adr;
            wr_reg_o.data = mem_wr_reg_i.data;
	    wr_reg_o.ena  = mem_wr_reg_i.ena;
	  end
        else
          begin
	    if( alu_wr_reg_i.ena && ( mem_wr_reg_i.ena==0 ) )
	      begin
	        wr_reg_o.adr  = alu_wr_reg_i.adr;
	        wr_reg_o.data = alu_wr_reg_i.data;
	        wr_reg_o.ena  = alu_wr_reg_i.ena;
	      end
	    else
	      begin
	        wr_reg_o.ena  = 1'b0;
	        wr_reg_o.adr  = 3'b0;
	        wr_reg_o.data = 16'b0;
	      end
	  end
      end
  end
endmodule
	

