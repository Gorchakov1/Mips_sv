`include "my_def";
`include "my_struct";
module AlU(
 input                     clk_i,
 input        [7:0]        alu_i,
 input        [11:0]       cnt_i,
 input                     haz_i,
 input  signal_data        data_i,
 output logic [15:0]       cnt_o,
 output logic              end_pr_o,
 output logic              haz_o,
 output signal_alu_wr_reg  alu_wr_reg_o
);
 logic [3:0]    op_code;
 logic [3:0]    adr_c;
 
 logic          flag_bolshe;
 logic          flag_menshe;
 logic          flag_ravno;
 
 logic          rav_adr;




always @(posedge clk_i)
 begin
   op_code <= alu_i[7:4];
   adr_c   <= alu_i[3:0];
 end

always_comb
 begin
   case( op_code )
     `OP_ADD: 
	begin
	  alu_wr_reg_o.data = data_i.a + data_i.b; 
	  alu_wr_reg_o.ena  = 1'b1;
	end
     `OP_MOV: 
        begin 
	  alu_wr_reg_o.data = data_i.b ; // mov a b
          alu_wr_reg_o.ena  = 1'b1;
        end
     `OP_CMP:
        begin
          if( data_i.a>data_i.b )
            begin
	      flag_bolshe       = 1'b1;
              flag_menshe       = 1'b0;
              flag_ravno        = 1'b0;
              alu_wr_reg_o.ena  = 1'b0;
	      alu_wr_reg_o.data = 1'b0;
	    end
          else
	    if( data_i.a<data_i.b ) 
	      begin
                flag_bolshe       = 1'b0;
                flag_menshe       = 1'b1;
                flag_ravno        = 1'b0;
		alu_wr_reg_o.data = 1'b0;
		alu_wr_reg_o.ena  = 1'b0;
	      end 
	    else 
	      if( data_i.a==data_i.b )
		begin
		  flag_bolshe       = 1'b0;
                  flag_menshe       = 1'b0;
                  flag_ravno        = 1;
		  alu_wr_reg_o.data = 16'b0;
		  alu_wr_reg_o.ena  = 1'b0;
		end
        end
     `OP_SEE:
	begin
          if( data_i.a[4:0]==data_i.b[4:0] && data_i.a<data_i.b )
            rav_adr = 1'b1;
          else
            rav_adr = 1'b0;
        end
     `OP_OR: 
	begin
          alu_wr_reg_o.data = data_i.a | data_i.b; // or g a b
	  alu_wr_reg_o.ena  = 1'b1;
        end
     `OP_AND:
	begin
	  alu_wr_reg_o.data = data_i.a & data_i.b; // and g a b
          alu_wr_reg_o.ena  = 1'b1;
        end 
     `OP_JMP: 
        begin 
	  cnt_o             = cnt_i;
	  alu_wr_reg_o.ena  = 1'b0;
	  alu_wr_reg_o.data = 16'b0;
	end
     `OP_JN: 
        begin
	  if( flag_bolshe==1 )
            begin
	      cnt_o             = 1'b0;
	      alu_wr_reg_o.ena  = 1'b0;
	      alu_wr_reg_o.data = 1'b0;
	    end
          else
            begin
	      cnt_o             = cnt_i + 16'b0;
	      alu_wr_reg_o.ena  = 1'b0;
	      alu_wr_reg_o.data = 1'b0;
            end
        end
     `OP_INC: 
	begin
	  alu_wr_reg_o.data = 1'b1 + data_i.b;
	  alu_wr_reg_o.ena  = 1'b1;
	end
     `OP_DEC: 
	begin
	  alu_wr_reg_o.data =  data_i.b - 1'b1; 
	  alu_wr_reg_o.ena  = 1'b1;
	end
     `OP_END: 
	begin
	  cnt_o    = 1'b0;
	end
     `OP_JR: 
        begin
	  if( rav_adr==1 )
	    begin
              cnt_o             = cnt_i;
	      alu_wr_reg_o.ena  = 1'b0;
	      alu_wr_reg_o.data = 1'b0;
	    end
	  else
	    begin
	      cnt_o             = 1'b0;
	      alu_wr_reg_o.ena  = 1'b0;
	      alu_wr_reg_o.data = 1'b0;
	    end 
	end  
     default :
       begin
	 cnt_o             = 1'b0;
	 alu_wr_reg_o.data = 1'b0;
	 alu_wr_reg_o.ena  = 1'b0;
       end
  endcase
  alu_wr_reg_o.adr = adr_c;
 end

always @ (posedge clk_i)
 begin
   haz_o <= haz_i;
 end


endmodule	
				 
				 
				 
				 
				
