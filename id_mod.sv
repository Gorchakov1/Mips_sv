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
 
  output       signal_flag_ena_id   flag_ena_o,

  output       signal_offset_id_reg offset_id_o,
  output       signal_in1           in1_o,
  output logic                      end_pr_o
);
logic [15:0]              instr;

logic [3:0]               op_cod;
logic [3:0]               in_adr_r;
logic [4:0]               in_adr_m;
logic [4:0]               in_of_adr;

logic [4:0]               wr_adr_reg;
logic [3:0]               wr_of_adr;
logic [4:0]               wr_adr_mem;

logic [11:0]              cnt;

logic [3:0]               adr_a1;
logic [3:0]               adr_a2;
 

assign op_cod     = instr[15:12];
assign in_adr_r   = instr[11:9];
assign in_adr_m   = instr[4:0];
assign in_of_adr  = instr[8:5];

assign wr_adr_reg = instr[11:8];
assign wr_of_adr  = instr[7:5];
assign wr_adr_mem = instr[4:0];

assign cnt        = instr[11:0];

assign adr_a1     = instr[7:4];
assign adr_a2     = instr[3:0];


always@ ( posedge clk_i )
  begin
    in1_o.adr_m        <= ( ( op_cod == `OP_WR && wr_of_adr ) == 0  ||
                            ( op_cod == `OP_IN && in_of_adr ) == 0  ) ? in_adr_m  : '0;
   
    in1_o.ena          <= ( op_cod == `OP_IN && in_of_adr == 0 ) ? '1        : '0;
    
    in1_o.adr_r        <= ( op_cod == `OP_IN                   ) ? in_adr_r  : '0;
    offset_id_o.adr_rm <= ( op_cod == `OP_IN && in_of_adr != 0 ) ? in_of_adr : '0;
    offset_id_o.ena    <= ( op_cod == `OP_IN && in_of_adr != 0 ) ? 1         : '0;
    
    reg_wr_mem_o.ena   <= ( op_cod == `OP_WR                   ) ? 1          : '0;
    ena_w_mem_o        <= ( op_cod == `OP_WR                   ) ? 1          : '0;
    reg_wr_mem_o.adr   <= ( op_cod == `OP_WR                   ) ? wr_adr_reg : '0;
  
    
    off_wr_mem_o.adr   <= ( op_cod == `OP_WR && wr_of_adr != 0 ) ? wr_of_adr  : '0;
    off_wr_mem_o.ena   <= ( op_cod == `OP_WR && wr_of_adr != 0 ) ? 1          : '0;
    

    cnt_o              <= ( op_cod == `OP_JMP || op_cod == `OP_JN || op_cod == `OP_JR ) ? cnt : '0;
    
    flag_ena_o.rav_adr <= ( op_cod == `OP_JR ) ? '1 : 0;
    flag_ena_o.ravno   <= ( op_cod == `OP_JN ) ? '1 : 0;
    flag_ena_o.bolshe  <= ( op_cod == `OP_JN ) ? '1 : 0;
    flag_ena_o.menshe  <= ( op_cod == `OP_JN ) ? '1 : 0;
             
    adr_regt_o.ena     <= (op_cod != 0       &&
                           op_cod != `OP_IN  &&
                           op_cod != `OP_JN  && 
                           op_cod != `OP_WR  && 
                           op_cod != `OP_JR  && 
                           op_cod != `OP_JMP     ) ? 1'b1   : 0;
    adr_regt_o.a1      <= (op_cod != 0       &&
                           op_cod != `OP_IN  && 
                           op_cod != `OP_JN  && 
                           op_cod != `OP_WR  && 
                           op_cod != `OP_JR  && 
                           op_cod != `OP_JMP     ) ? adr_a1 : '0;
    adr_regt_o.a2      <= (op_cod != 0       &&
                           op_cod != `OP_IN  && 
                           op_cod != `OP_JN  && 
                           op_cod != `OP_WR  &&
                           op_cod != `OP_JR  && 
                           op_cod != `OP_JMP     ) ? adr_a2 : '0;
  end


assign instr    = instr_i;
assign alu_o    = instr[15:8];
assign end_pr_o = ( op_cod == `OP_END ) ? '1 : '0;

always @ (posedge rst or posedge clk_i)
  begin
    if( rst )
      haz_o <= 0;
    else
      haz_o <= haz_o+1'b1;
  end



endmodule 


