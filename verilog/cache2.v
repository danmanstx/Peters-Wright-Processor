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
module cache(addr_in, data_in, rw_in, ce_in, addr_out, data_out, rw_out, ce_out, odv, clr, clk);
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
    wire hit;                       //hit=1 for a hit, hit=0 for a miss
    wire [1:0] sel;                 //sel=i if hit at entry i
    reg [1:0] sel_reg;              //register to store sel between ccs
    wire [3:0] dec;                 //dec[i]=1 if decrementing cnt[i]

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
    
    //modules
    determine_hit DETERMINE_HIT (addr_in, w_addr, w_cnt, valid, sel, dec, hit);
    
    /////////////////////////////////////////
    //FSM
    /////////////////////////////////////////
    always@(posedge clk)
    begin
        if(clr == 0 || ce_in == 0)
        begin
            state <= 0;
            rw_in_reg <= 0;
            data_in_reg <= 0;
            addr_in_reg <= 0;
        end
        else
        begin
            rw_in_reg <= rw_in;
            data_in_reg <= data_in;
            addr_in_reg <= addr_in;
            case(state)
                0: begin
                    if(hit == 1)
                        state <= 0;
                    else
                        state <= 1;
                end
                1:  begin
                    if(rw_in == 1)
                        state <= 2;
                    else
                        state <= 4;
                end
                2:  state <= 3;
                3:  state <= 6;
                4:  state <= 5;
                5:  state <= 6;
                6:  state <= 7;
                7:  state <= 8;
                8:  state <= 9;
                9:  state <= 0;
                default: state <= 0;
            endcase
        end
    end
    
    /////////////////////////////////////////
    //State outputs
    /////////////////////////////////////////
    always@(negedge clk)
    begin
        case(state)
        0:
        begin
            ce_out <= 0;
            rw_out <= 0;
            data_out_reg <= 0;
            addr_out <= 0;
            sel_reg <= sel;

            if(hit == 1)    //hit
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
                if(rw_in_reg == 0) //write
                    data[sel] <= data_in_reg;
                else        //read
                    data_inout_reg <= data[sel];
            end
            else            //miss
            begin
                odv <= 0;
            end
        end
        1:
        begin
            //write to RAM
            odv <= 0;
            ce_out <= 1;
            rw_out <= 0;
            data_out_reg <= data[sel_reg];
            addr_out <= addr[sel_reg];
        end
        2:
        begin
            //write from bus to cache
            odv <= 0;
            ce_out <= 0;
            rw_out <= 0;
            data_out_reg <= 0;
            addr_out <= 0;
            data[sel_reg] <= data_in_reg;
            valid[sel_reg] <= 1;
            addr[sel_reg] <= addr_in_reg;
            if(sel_reg != 0)
                cnt[0] <= cnt[0] - 1;
            else
                cnt[0] <= 2'b11;
            if(sel_reg != 1)
                cnt[1] <= cnt[1] - 1;
            else
                cnt[1] <= 2'b11;
            if(sel_reg != 2)
                cnt[2] <= cnt[2] - 1;
            else
                cnt[2] <= 2'b11;
            if(sel_reg != 3)
                cnt[3] <= cnt[3] - 1;
            else
                cnt[3] <= 2'b11;
        end
        3:
        begin
            //do nothing
            odv <= 0;
            ce_out <= 0;
        end
        4:
        begin
            //write from RAM to cache
            odv <= 0;
            ce_out <= 1;
            rw_out <= 1;
            data_out_reg <= data_in_reg;
            addr_out <= addr_in_reg;
        end
        5:
        begin
            //write what is on the RAM lines
            odv <= 0;
            ce_out <= 0;
            rw_out <= 0;
            data_out_reg <= 0;
            addr_out <= 0;
            data[sel_reg] <= data_out;
            //write data to cache bus
            data_inout_reg <= data_out;
            valid[sel_reg] <= 1;
            addr[sel_reg] <= addr_in_reg;
            if(sel_reg != 0)
                cnt[0] <= cnt[0] - 1;
            else
                cnt[0] <= 2'b11;
            if(sel_reg != 1)
                cnt[1] <= cnt[1] - 1;
            else
                cnt[1] <= 2'b11;
            if(sel_reg != 2)
                cnt[2] <= cnt[2] - 1;
            else
                cnt[2] <= 2'b11;
            if(sel_reg != 3)
                cnt[3] <= cnt[3] - 1;
            else
                cnt[3] <= 2'b11;
        end
        6:
        begin
            //do nothing
            odv <= 0;
            ce_out <= 0;
        end
        7:
        begin
            //do nothing
            odv <= 0;
            ce_out <= 0;
        end
        8:
        begin
            //do nothing
            odv <= 0;
            ce_out <= 0;
        end
        9:
        begin
            //data is valid
            odv <= 1;
            ce_out <= 0;
        end
        default:
        begin
            //do nothing
            odv <= 0;
            ce_out <= 0;
        end
        endcase
    end

    genvar i;
    wire i_bufc;    //in buffer control
    wire o_bufc;    //out buffer control

    assign i_bufc = ~rw_in;
    assign o_bufc = rw_out;

    generate
    for(i = 0; i < d_width; i = i + 1)
    begin
        bufif1 (data_out,data_out_reg,o_bufc);
        bufif1 (data_in,data_inout_reg,i_bufc);
    end
    endgenerate

endmodule
