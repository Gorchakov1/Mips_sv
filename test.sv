`include "my_struct";
`include "my_def";
module test ;
 logic                  clk;
 logic                  rst;

 logic [15:0]           cnt_t;
 logic [15:0]           cnt_hz;
 
 logic [11:0]           cnt_id;
 logic [15:0]           cnt_new;

 logic [15:0]           instr;
 logic [7:0]            alu_1;
 logic                  wr_ena_mem;

 signal_in1             in1;
 signal_offset_id_reg   offset_id_reg;
 signal_offset_reg_mem  offset_reg_mem;

 signal_adr_regt        adr_regt;
 signal_data            data;

 signal_mem_wr_reg      mem_wr_reg;
 signal_alu_wr_reg      alu_wr_reg;
 signal_wr_reg          wr_reg    ;

 signal_reg_wr_mem      reg_wr_mem;
 logic [15:0]           datamem;
 signal_off_wr_mem      off_wr_mem;
 signal_off_mem         off_mem;

 integer                wr_d;


initial 
 begin
   clk = 1'b0;
   forever
     begin
       #10.0 clk = ~clk;
     end
 end

initial 
 begin
   rst = 1'b1;
   #11.0 rst = 1'b0;
 end



counter cn(
.rst   (rst),
.cnt_o (cnt_t),
.clk_i (clk),
.haz_i (hazard),
.cnt_i (cnt_new)
);


instrmem_mem im(
.cnt_i   (cnt_hz),
.instr_o (instr)
);


id_mod id(
.clk_i        (clk),
.instr_i      (instr),
.cnt_o        (cnt_id),
.rst          (rst),
.off_wr_mem_o (off_wr_mem),
.haz_o        (haz),
.alu_o        (alu_1),
.adr_regt_o   (adr_regt),
.ena_w_mem_o  (wr_ena_mem),
.in1_o        (in1),
.offset_id_o  (offset_id_reg),
.reg_wr_mem_o (reg_wr_mem)
 );
 
data_mem dm(
.clk_i        (clk),
.rst          (rst),
.d_out        (wr_d),
.off_wr_mem_i (off_mem),
.ena_wr_i     (wr_ena_mem),
.data_wr_i    (datamem),
.offset_reg_i (offset_reg_mem),
.mem_wr_reg_o (mem_wr_reg),
.in1_i        (in1)
);
 
regfile re (
.clk_i        (clk),
.rst          (rst),
.data_o       (data),
.off_wr_mem_i (off_wr_mem),
.out_1r_o     (datamem),
.off_wr_mem_o (off_mem),
.adr_regt_i   (adr_regt),
.wr_reg_i     (wr_reg),
.offset_reg_o (offset_reg_mem),
.offset_id_i  (offset_id_reg),
.reg_wr_mem_i (reg_wr_mem)
); 

AlU al(
.clk_i        (clk),
.alu_i        (alu_1),
.cnt_i        (cnt_id),
.cnt_o        (cnt_new),
.data_i       (data),
.alu_wr_reg_o (alu_wr_reg),
.haz_i        (haz),
.haz_o        (hazard)
);





mult ml(
.mem_wr_reg_i (mem_wr_reg),
.alu_wr_reg_i (alu_wr_reg),
.wr_reg_o     (wr_reg)
); 

hazard hz(
.clk_i     (clk),
.rst       (rst),
.haz_i     (haz),
.cnt_jmp_i (cnt_new),
.cnt_i     (cnt_t),
.cnt_o     (cnt_hz)
);
 
endmodule
