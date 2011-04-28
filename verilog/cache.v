`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//cache.v
//
//A parameterized cache module.  The cache is fully associative and implements the
//least recently utilized replacement algorithm.  The cache contains four entries.
//The cache delay is modeled using a FSM.
//
///////////////////////////////////////////////////////////////////////////////////////
module cache(addr_in, data_in, rw_in, ce_in, addr_out, data_out, rw_out, ce_out, odv, clr, clk,
             hit, data0, data1, data2, data3, addr0, addr1, addr2, addr3);
    //parameters
    parameter d_width = 8;      //data bus width
    parameter a_width = 8;      //address line width

    //inputs to the cache
    input [a_width-1:0] addr_in;        //address in
    reg [a_width-1:0] addr_in_reg;      //register that stores address in
    inout [d_width-1:0] data_in;        //data bus into the cache
    reg [d_width-1:0] data_in_reg;      //data in register
    reg [d_width-1:0] data_inout_reg;   //data in register (for output)
    input rw_in;                        //read if rw=1 write if rw=0
    reg rw_in_reg;                      //store rw
    input ce_in;                        //chip enable (func. when ce=1, HiZ when ce=0)

    //outputs to RAM
    output reg [a_width-1:0] addr_out;  //address out
    inout [d_width-1:0] data_out;       //data bus from the cache
    reg [d_width-1:0] data_out_reg;     //data out register (for output)
    output reg rw_out;                  //pass from input
    output reg ce_out;                  //pass from output
    output reg odv;                     //output data valid

    //control inputs
    input clr;                      //synchronous active low clear
    input clk;                      //clock

    //cache entries
    reg [3:0] valid;                //entry valid
    reg [1:0] cnt [3:0];            //count (for LRU replacement)
    reg [d_width-1:0] data [3:0];   //entry data
    reg [a_width-1:0] addr [3:0];   //entry addresses

    //other registers and wires
    reg [3:0] state;
    output hit;                       //hit=1 for a hit, hit=0 for a miss
    wire [1:0] sel;                 //sel=i if hit at entry i
    reg [1:0] sel_reg;              //register to store sel between ccs
    wire [3:0] dec;                 //dec[i]=1 if decrementing cnt[i]
    integer i;

    //wire wrappers
    wire [(a_width*4)-1:0] w_addr;
    wire [7:0] w_cnt;
    assign w_addr[a_width-1:0] = addr[0];
    assign w_addr[(a_width*2)-1:a_width] = addr[1];
    assign w_addr[(a_width*3)-1:(a_width*2)] = addr[2];
    assign w_addr[(a_width*4)-1:(a_width*3)] = addr[3];
    assign w_cnt[1:0] = cnt[0];
    assign w_cnt[3:2] = cnt[1];
    assign w_cnt[5:4] = cnt[2];
    assign w_cnt[7:6] = cnt[3];
    
    output [7:0] data0;
    assign data0 = data[0];
    output [7:0] data1;
    assign data1 = data[1];
    output [7:0] data2;
    assign data2 = data[2];
    output [7:0] data3;
    assign data3 = data[3];
    output [7:0] addr0;
    assign addr0 = addr[0];
    output [7:0] addr1;
    assign addr1 = addr[1];
    output [7:0] addr2;
    assign addr2 = addr[2];
    output [7:0] addr3;
    assign addr3 = addr[3];
    
    //modules
    determine_hit DETERMINE_HIT (addr_in, w_addr, w_cnt, valid, sel, dec, hit);
    

    initial
    begin
        rw_in_reg = 0;
        data_in_reg = 0;
        data_inout_reg = 0;
        data_out_reg = 0;
        addr_in_reg = 0;
        addr_out = 0;
        state = 0;
        sel_reg = 0;
        for(i = 0; i < 4; i = i + 1)
        begin
            valid[i] = 0;
            cnt[i] = 0;
            data[i] = 0;
            addr[i] = 0;
        end
        rw_out = 0;
        ce_out = 0;
        odv = 0;
    end

    always@(posedge clk)
    begin
        if(clr == 0 || ce_in == 0)
        begin
            state <= 0;
        end
        else
        begin
            case(state)
            0:  if(hit == 1)
                    state <= 0;
                else if(valid[sel] == 1)
                    state <= 1;
                else
                    state <= 3;
            1:  state <= 2;
            2:  if(rw_in_reg == 0)
                    state <= 5;
                else
                    state <= 8;
            3:  state <= 4;
            4:  if(rw_in_reg == 0)
                    state <= 5;
                else
                    state <= 8;
            5:  state <= 6;
            6:  state <= 7;
            7:  state <= 11;
            8:  state <= 9;
            9:  state <= 10;
            10: state <= 11;
            11: state <= 12;
            12: state <= 0;
            default: state <= 0;
            endcase
        end
    end
    
    always@(negedge clk)
    begin
        if(clr == 0)
        begin
            for(i = 0; i < 4; i = i + 1)
            begin
                addr[i] <= 0;
                data[i] <= 0;
                valid[i] <= 0;
                cnt[i] <= 0;
            end
        end
        if(ce_in == 1)
        begin
            rw_in_reg <= rw_in;
            data_in_reg <= data_in;
            addr_in_reg <= addr_in;
            sel_reg <= sel;
            case(state)
            0:  //initial state
            begin
                ce_out <= 0;
                rw_out <= 0;
                if(hit == 1) //hit
                begin
                    odv <= 1;
                    if(dec[0] == 1 && sel != 0)
                        cnt[0] <= cnt[0] - 1;
                    if(dec[1] == 1 && sel != 1)
                        cnt[1] <= cnt[1] - 1;
                    if(dec[2] == 1 && sel != 2)
                        cnt[2] <= cnt[2] - 1;
                    if(dec[3] == 1 && sel != 3)
                        cnt[3] <= cnt[3] - 1;
                    cnt[sel] <= 2'b11;
                    if(rw_in_reg == 0)  //write
                        data[sel] <= data_in_reg;
                    else
                        data_inout_reg <= data[sel];
                end
                else
                begin
                    odv <= 0;
                end
            end
            1:      //write back to RAM state
            begin
                odv <= 0;
                ce_out <= 1;
                rw_out <= 0;
                data_out_reg <= data[sel_reg];
                addr_out <= addr[sel_reg];
            end
            2:      //write back to RAM state 2
            begin
                odv <= 0;
                ce_out <= 1;
                rw_out <= 0;
                data_out_reg <= data[sel_reg];
                addr_out <= addr[sel_reg];
            end
            3:      //do nothing
            begin
                odv <= 0;
                ce_out <= 0;
            end
            4:      //do nothing
            begin
                odv <= 0;
                ce_out <= 0;
            end
            5:      //write to cache from bus
            begin
                odv <= 0;
                ce_out <= 0;
                data[sel_reg] <= data_in_reg;
                addr[sel_reg] <= addr_in_reg;
                valid[sel_reg] <= 1;
                for(i = 0; i < 4; i = i + 1)
                begin
                    if(valid[i] == 1)
                        cnt[i] <= cnt[i] - 1;
                end
            end
            6:      //do nothing
            begin
                odv <= 0;
                ce_out <= 0;
            end
            7:      //do nothing
            begin
                odv <= 0;
                ce_out <= 0;
            end
            8:      //read from RAM to cache
            begin
                odv <= 0;
                ce_out <= 1;
                rw_out <= 1;
                addr_out <= addr_in_reg;
            end
            9:
            begin
                odv <= 0;
                ce_out <= 1;
                rw_out <= 1;
                data[sel_reg] <= data_out;
                addr[sel_reg] <= addr_in_reg;
                valid[sel_reg] <= 1;
                addr_out <= addr_in_reg;
                for(i = 0; i < 4; i = i + 1)
                begin
                    if(valid[i] == 1)
                        cnt[i] <= cnt[i] - 1;
                end
            end
            10:     //do nothing
            begin
                odv <= 0;
                ce_out <= 0;
            end
            11:     //do nothing
            begin
                odv <= 0;
                ce_out <= 0;
                data_inout_reg <= data[sel_reg];
            end
            12:     //data is valid
            begin
                odv <= 1;
                ce_out <= 0;
                data_inout_reg <= data[sel_reg];
            end
            default:
            begin
                odv <= 1;
                ce_out <= 0;
            end
            endcase
        end
    end

    
    genvar j;
    
    generate
    for(j = 0; j < d_width; j = j + 1)
    begin:buffers
        bufif0 (data_out[j],data_out_reg[j],rw_out);
        bufif1 (data_in[j],data_inout_reg[j],rw_in);
    end
    endgenerate

endmodule
