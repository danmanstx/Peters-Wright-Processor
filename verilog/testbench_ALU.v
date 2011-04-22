`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//testbench_ALU.v
//
//A test bench for testing the ALU functionality.  Not used in final design.
//
//    ctrl cin  funct
//    000   0    A+B
//    000   1    A-B
//    001   0    A|B
//    001   1    A|~B
//    010   0    A&B
//    010   1    A&~B
//    011   0    ~A
//    011   1    ~B
//    100   0    LSL A by B
//    100   1    LSR A by B
//    101   0    A|B
//    101   1    A|~B
//    110   0    A&B
//    110   1    A&~B
//    111   0    A
//    111   1    B
//
//Having the following outputs:
//    f     result
//    v     v=1 if overflow
//    z     z=1 if f=0
//    cout  carry out
//
///////////////////////////////////////////////////////////////////////////////////////
module testbench_ALU(v_in,uut_out,err);
    parameter n=4;
    parameter m=2;
    input [2*n+3:0] v_in;
    output [n+2:0] uut_out;
    output reg err;
    
    //input wires
    wire [n-1:0] A;
    wire [n-1:0] B;
    wire cin;
    wire ctrl;
    assign A = v_in[2*n+3:n+4];
    assign B = v_in[n+3:4];
    assign ctrl = v_in[3:1];
    assign cin = v_in[0];
    
    //output wires
    reg [n+2:0] cor_out;
    
    //module n_bit_ALU(a, b, cin, ctrl, f, cout, v, z);
    n_bit_ALU #(.n(n),.m(m)) UUT (A, B, cin, ctrl, uut_out[n-1:0], uut_out[n], uut_out[n+1], uut_out[n+2]);
    
    always@(v_in)
    begin
        case({ctrl,cin})
        4'b0000: cor_out[n:0] = A+B;
        4'b0001: cor_out[n:0] = A-B;
        4'b0010: begin cor_out[n-1:0] = A|B; cor_out[n] = cin; end
        4'b0011: begin cor_out[n-1:0] = A|~B; cor_out[n] = cin; end
        4'b0100: begin cor_out[n-1:0] = A&B; cor_out[n] = cin; end
        4'b0101: begin cor_out[n-1:0] = A&~B; cor_out[n] = cin; end
        4'b0110: begin cor_out[n-1:0] = ~A; cor_out[n] = cin; end
        4'b0111: begin cor_out[n-1:0] = ~B; cor_out[n] = cin; end
        4'b1000: begin cor_out[n-1:0] = A|B; cor_out[n] = cin; end
        4'b1001: begin cor_out[n-1:0] = A << B; cor_out[n] = cin; end
        4'b1010: begin cor_out[n-1:0] = A >> B; cor_out[n] = cin; end
        4'b1011: begin cor_out[n-1:0] = A|~B; cor_out[n] = cin; end
        4'b1100: begin cor_out[n-1:0] = A&B; cor_out[n] = cin; end
        4'b1101: begin cor_out[n-1:0] = A&~B; cor_out[n] = cin; end
        4'b1110: begin cor_out[n-1:0] = A; cor_out[n] = cin; end
        4'b1111: begin cor_out[n-1:0] = B; cor_out[n] = cin; end
        default: cor_out[n:0] = 0;
        endcase
        //zero detect
        if(cor_out[n-1:0] == 0)
            cor_out[n+2] = 1;
        else
            cor_out[n+2] = 0;
        if(cor_out[n-1] != A[n-1] && cor_out[n-1] != B[n-1] && ctrl == 3'b000 && cin == 1'b0 )      //overflow detect (addition)
            cor_out[n+1] = 1;
        else if(A[n-1] != B[n-1] && cor_out[n-1] != A[n-1] && ctrl == 3'b000 && cin == 1'b1 )       //overflow detect (subtraction)
            cor_out[n+1] = 1;
        else
            cor_out[n+1] = 0;
    end

    always@(uut_out or cor_out)
    begin
        if(uut_out == cor_out)
            err = 0;
        else
            err = 1;
    end
endmodule
