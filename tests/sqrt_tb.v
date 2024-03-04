`timescale 1ns / 1ps

module sqrt_tb;

    reg clk;
    reg rst;
    reg start;
    wire [ 1 : 0 ] busy; 
    reg [ 9:0 ] in_test;
    wire [ 4:0 ] out_test;   
    sqrt qrt1 (.clk_i(clk), .rst_i(rst), .a_bi(in_test), .start_i(start), .busy_o(busy), .y_bo (out_test));

    task test_sqrt;
        input [3:0] numb;
        input [9:0] x;
        input [4:0] expected_x;
        begin
            rst = 1;
            #2
            rst = 0;
            in_test = x;
            start = 1;
            #2
            start = 0;
            while (busy) begin
                #5;
            end
            if (out_test == expected_x) $display ( "Test ", numb, ". The sqrt output is correct. test_out =", out_test, " , expected_out =" , expected_x) ;
            else  $display ( "Test ", numb, ". The sqrt output is incorrect. test_out =", out_test, " , expected_out =" , expected_x) ;
        end
    endtask

    initial begin
        clk = 0;
        test_sqrt(1, 0, 0);
        test_sqrt(2, 1, 1);
        test_sqrt(3, 2, 1);
        test_sqrt(4, 4, 2);
        test_sqrt(5, 16, 4);
        test_sqrt(6, 17, 4);
        test_sqrt(7, 36, 6);
        test_sqrt(8, 100, 10);
        test_sqrt(9, 255, 15);
        test_sqrt(10, 261, 16);        
    end   
    
    always begin
        #1  clk = !clk;
    end    

endmodule