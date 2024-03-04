`timescale 1ns / 1ps

module func_tb;

    reg clk;
    reg rst;
    reg start;
    wire [ 1 : 0 ] busy; 
    reg [ 7 : 0 ] in_test_a;
    reg [ 7 : 0 ] in_test_b;
    wire [ 4 : 0 ] out_test;   
    func func1 (.clk_i(clk), .rst_i(rst), .a_bi(in_test_a), .b_bi(in_test_b), .start_i(start), .busy_o(busy), .y_bo (out_test));

    task test_func;
        input [3:0] numb;
        input [7:0] a;
        input [7:0] b;
        input [4:0] expected_y;
        begin
            rst = 1;
            #2
            rst = 0;
            in_test_a = a;
            in_test_b = b;
            start = 1;
            #2
            start = 0;
            while (busy) begin
                #20;
            end
            if (out_test == expected_y) $display ( "Test ", numb, ". The cbrt output is correct. test_out =", out_test, " , expected_out =" , expected_y) ;
            else  $display ( "Test ", numb, ". The cbrt output is incorrect. test_out =", out_test, " , expected_out =" , expected_y) ;
        end
    endtask

    initial begin
        clk = 0;
        test_func(1, 0, 0, 0);
        test_func(2, 1, 1, 1);
        test_func(3, 12, 60, 3);
        test_func(4, 123, 223, 11);
        test_func(5, 255, 255, 16);   
    end   
    
    always begin
        #1  clk = !clk;
    end    

endmodule