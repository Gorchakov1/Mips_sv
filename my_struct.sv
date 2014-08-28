`ifndef _my_sruct
`define _my_sruct

typedef struct packed { 
logic [15:0] data; 
logic [3:0] adr; 
logic ena;
} signal_alu_wr_reg;


typedef struct packed { 
logic [15:0] data; 
logic [3:0] adr; 
logic ena;
} signal_mem_wr_reg;



typedef struct packed { 
logic [15:0] data; 
logic [3:0] adr; 
logic ena;
} signal_wr_reg;

typedef struct packed { 
logic [15:0] a;
logic [15:0] b;
} signal_data;


typedef struct packed { 
logic [3:0] a1;
logic [3:0] a2;
logic ena;
} signal_adr_regt;

typedef struct packed { 
logic [4:0] adr_m;
logic [3:0] adr_r;
logic ena;
} signal_in1;


typedef struct packed { 
logic [3:0] adr;
logic ena;
} signal_reg_wr_mem;

typedef struct packed { 
logic [3:0] adr_rm;
logic ena;
} signal_offset_id_reg;

typedef struct packed { 
logic [4:0] adr;
logic ena;
} signal_offset_reg_mem;

typedef struct packed { 
logic [4:0] adr;
logic ena;
} signal_off_wr_mem;


typedef struct packed { 
logic [4:0] adr;
logic ena;
} signal_off_mem;


`endif 
