`timescale 1ns / 1ps
module sqrt (        
        input clk_i,
        input rst_i,        
        input [ 9 : 0 ] a_bi,       
        input start_i,
        output [ 1 : 0 ] busy_o,   
        output reg [ 4 : 0 ] y_bo
    );
        
    localparam IDLE = 2'h0;
    localparam WORK_CALC = 2'h1;    
    localparam WORK_COLLECT = 2'h2;  
    
    reg [8:0] ctr; //m
    wire end_step = (ctr == 0);   
    reg [9:0] part_res; //y
    reg [9:0] b;   
    reg [9:0] a; //x  
    reg [1:0] state;
    wire a_more_than_b = (a >= b); 
    
    assign busy_o = (state != IDLE);
    
    always @(posedge clk_i)
        if (rst_i) begin            
            ctr <= 0;
            part_res <= 0;            
            y_bo <= 0;
            state <= IDLE;        
        end else begin
            case (state)                
                IDLE :
                    if (start_i) begin                        
                        state <= WORK_CALC;
                        a <= a_bi;    
                        ctr <= 1 << 8;                        
                        part_res <= 0;
                    end                
                WORK_CALC:
                    begin                        
                        if (end_step) begin
                            state <= IDLE;                            
                            y_bo <= part_res[4:0];
                        end else begin 
                            state <= WORK_COLLECT;                       
                            part_res <= part_res >> 1;
                            b <= part_res | ctr;
                        end                   
                    end
                 WORK_COLLECT:
                    begin                        
                        if (a_more_than_b) begin
                            a <= a - b;                         
                            part_res <= part_res | ctr;
                        end 
                        state <= WORK_CALC;                       
                        ctr <= ctr >> 2;               
                    end
            endcase  
        end
endmodule