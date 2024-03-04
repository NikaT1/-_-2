`timescale 1ns / 1ps

module cbrt_tb;

    reg clk;
    reg rst;
    reg start;
    wire [ 1 : 0 ] busy; 
    reg [ 7 : 0 ] in_test;
    wire [ 3 : 0 ] out_test;   
    cbrt cbrt1 (.clk_i(clk), .rst_i(rst), .a_bi(in_test), .start_i(start), .busy_o(busy), .y_bo (out_test));

    task test_cbrt;
        input [3:0] numb;
        input [7:0] x;
        input [3:0] expected_x;
        begin
            rst = 1;
            #2
            rst = 0;
            in_test = x;
            start = 1;
            #2
            start = 0;
            while (busy) begin
                #20;
            end
            if (out_test == expected_x) $display ( "Test ", numb, ". The cbrt output is correct. test_out =", out_test, " , expected_out =" , expected_x) ;
            else  $display ( "Test ", numb, ". The cbrt output is incorrect. test_out =", out_test, " , expected_out =" , expected_x) ;
        end
    endtask

    initial begin
        clk = 0;
        test_cbrt(1, 200, 5);
        test_cbrt(2, 1, 1);
        test_cbrt(3, 2, 1);
        test_cbrt(4, 8, 2);
        test_cbrt(5, 9, 2);
        test_cbrt(6, 28, 3);
        test_cbrt(7, 68, 4);
        test_cbrt(8, 125, 5);
        test_cbrt(9, 200, 5);
        test_cbrt(10, 255, 6);    
    end   
    
    always begin
        #1  clk = !clk;
    end    

endmodule