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
  output  signal_data           data_o,

  input   signal_flag_ena_id    flag_ena_i,
  input   signal_flag_wr_alu    flag_wr_i,
  output  signal_flag_alu       flag_alu_o
);

logic [7:0][15:0] regs;
logic             flag_ravno;
logic             flag_bolshe;
logic             flag_menshe;
logic             flag_rav_adr;

logic [2:0]       reg_wr_mem;
logic [2:0]       off_wr_mem;
logic [2:0]       adr_a1;
logic [2:0]       adr_a2;
logic [2:0]       offset_id;
logic [2:0]       wr_reg;


assign reg_wr_mem = reg_wr_mem_i.adr[2:0];
assign off_wr_mem = off_wr_mem_i.adr[2:0];
assign adr_a1     = adr_regt_i.a1[2:0];
assign adr_a2     = adr_regt_i.a2[2:0];
assign offset_id  = offset_id_i.adr_rm[2:0];
assign wr_reg     = wr_reg_i.adr[2:0];


assign out_1r_o         = ( reg_wr_mem_i.ena == 0)? 16'b0  : regs[reg_wr_mem];
assign off_wr_mem_o.adr = ( off_wr_mem_i.ena == 0)? 16'b0  : regs[off_wr_mem];
assign data_o.a         = ( adr_regt_i.ena == 0  )? 16'b0  : regs[adr_a1];
assign data_o.b         = ( adr_regt_i.ena == 0  )? 16'b0  : regs[adr_a2];
assign offset_reg_o.adr = (offset_id_i.ena == 0  )? 5'b0   : regs[offset_id];

assign flag_alu_o.ravno   = (flag_ena_i.ravno == 0  )? 1'b0  : flag_ravno;
assign flag_alu_o.bolshe  = (flag_ena_i.bolshe == 0 )? 1'b0  : flag_bolshe;
assign flag_alu_o.menshe  = (flag_ena_i.menshe == 0 )? 1'b0  : flag_menshe;
assign flag_alu_o.rav_adr = (flag_ena_i.rav_adr == 0)? 1'b0  : flag_rav_adr;


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



always_ff@ ( posedge clk_i or posedge rst )
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
            regs[wr_reg] <= wr_reg_i.data;
          end
      end
  end


always_ff@ ( posedge clk_i or posedge rst )
  begin
    if( rst )
      begin
        flag_ravno   <= 1'b0;
        flag_bolshe  <= 1'b0;
        flag_menshe  <= 1'b0;
        flag_rav_adr <= 1'b0;
      end
    else
      begin
        if( flag_wr_i.ena )
          begin
            flag_ravno  <= flag_wr_i.ravno;
            flag_bolshe <= flag_wr_i.bolshe;
            flag_menshe <= flag_wr_i.menshe;
          end
      end
  end

always_ff@ ( posedge clk_i or posedge rst )
  begin
    if( rst )
      begin
        flag_rav_adr <= 1'b0;
      end
    else
      begin
        if( flag_wr_i.ena_ra )
          begin
            flag_rav_adr <= flag_wr_i.rav_adr;
          end
      end
  end

endmodule 
