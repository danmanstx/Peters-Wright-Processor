`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//n_bit_ALU.v
//
//An ALU that implements the following function table:
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
module n_bit_ALU(a, b, cin, ctrl, f, cout, v, z);
    parameter n = 4;        //data width
    parameter m = 2;        //shift width =log(n)
    input [n-1:0] a;        //A input
    input [n-1:0] b;        //B input
    input cin;              //carry in (inverts B)
    input [2:0] ctrl;       //control inputs
    output [n-1:0] f;       //output
    output cout;            //carry out
    output v;               //v=1 if overflow
    wire v_w;               //disable overflow if not adding or subtracting
    wire v_s;               //
    output z;               //z=1 if f=0
    
    wire [n:0] carry;
    wire [n-1:0] or_chain;
    wire [n-1:0] w_0;
    wire [n-1:0] w_1;
    wire [n-1:0] w_2;
    wire [n-1:0] w_3;
    wire w_sel;
    assign carry[0] = cin;
    assign cout = carry[n] & ~ctrl[2];
    assign or_chain[0] = f[0];
    genvar i;
    
    assign w_sel = (ctrl[2] & ~ctrl[1] & ~ctrl[0]) | (ctrl[2] & ctrl[1] & ctrl[0]);
    n_bit_shifter #(.max_s_bits(m)) SHIFTER (a, b, w_2, cin);
    MUX_mxn #(.d_width(n),.s_lines(1)) SELMUX ({b,a} , cin, w_3);
    MUX_mxn #(.d_width(n),.s_lines(1)) SHIFTMUX0 ({w_3,w_2} , ctrl[0], w_1);
    MUX_mxn #(.d_width(n),.s_lines(1)) SHIFTMUX1 ({w_1,w_0} , w_sel, f);
    
    generate    //create bistlice instances
    for(i = 0; i < n; i = i + 1)
    begin:alu_loop
        //ALU_bitslice(a,b,cin,ctrl,fout,cout);
        ALU_bitslice BSLICE (a[i],b[i],carry[i],ctrl[1:0],w_0[i],carry[i+1]);
    end
    for(i = 0; i < n - 1; i = i + 1)
    begin:or_loop
        or OR (or_chain[i+1],f[i+1],or_chain[i]);
    end
    endgenerate
    
    //overflow
    xor(v_w,carry[n-1],carry[n]);
    assign v_s = (~ctrl[2] & ~ctrl[1] & ~ctrl[0]);
    and(v,v_w,v_s);
    //zero
    not(z,or_chain[n-1]);

endmodule
