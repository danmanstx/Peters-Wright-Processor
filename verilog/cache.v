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
    reg [d_width-1:0] data_in_reg;      //data in register (for output)
    input rw_in;                        //read if rw=1 write if rw=0
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
    reg [2:0] timer;                //timer for a miss
    wire hit;                       //hit=1 for a hit, hit=0 for a miss
    wire [1:0] sel;                 //sel=i if hit at entry i
    reg [1:0] sel_reg;              //register to store sel between ccs
    wire [3:0] dec;                 //dec[i]=1 if decrementing cnt[i]
    integer i;

    //modules
    determine_hit DETERMINE_HIT (addr_in, addr, cnt, valid, sel, dec, hit);

    always@(posedge clk)
    begin
        if(clr == 1'b0)             //clear contents
        begin
            data_out_reg <= 1'b0;
            data_in_reg <= 1'b0;
            timer <= 1'b0;
            for(i = 0; i < 3; i = i+1)
            begin
                valid[i] <= 1'b0;
                cnt[i] <= 1'b0;
                data[i] <= 1'b0;
                addr[i] <= 1'b0;
            end
        end
        if(ce_in == 1'b1)           //only read or write if chip is enabled
        begin
            case(timer)             //timer acts as FSM for cache
                3'b000:
                begin
                    if(hit == 1'b1)     //hit
                    begin
                        if(rw_in == 1'b0)  //write
                            data[sel] <= data_in;
                        else            //read
                            data_in_reg <= data[sel];
                        cnt[sel] <= 2'b11;
                        ce_out <= 1'b0;
                        odv <= 1'b1;    //data is valid
                        timer <= 3'b000;
                    end
                    else            //miss
                    begin
                        if(valid[sel] == 1'b1)
                        begin
                            rw_out <= 1'b0;
                            data_out_reg <= data[sel];
                            addr_out <= addr[sel];
                            ce_out <= 1'b1;
                        end
                        else
                            ce_out <= 1'b0;
                        data_in_reg <= data_in;
                        sel_reg <= sel;
                        addr_in_reg <= addr_in;
                        odv <= 1'b0;
                        timer <= 3'b001;
                    end
                end
                3'b001:
                begin
                    //perform read or write for miss
                    if(rw_in == 1'b0)  //write
                    begin
                        data[sel_reg] <= data_in_reg;
                    end
                    else            //read
                    begin
                        data_in_reg <= data[sel_reg];
                    end
                    cnt[sel_reg] <= 2'b11;
                    valid[sel_reg] <= 1'b1;
                    addr_out <= addr_in_reg;
                    ce_out <= 1'b1;
                    odv <= 1'b0;
                    timer <= 3'b010;
                end
                3'b010:
                begin
                    ce_out <= 1'b0;
                    odv <= 1'b0;
                    timer <= 3'b011;
                end
                3'b011:
                begin
                    ce_out <= 1'b0;
                    odv <= 1'b0;
                    timer <= 3'b100;
                end
                3'b100:
                begin
                    ce_out <= 1'b0;
                    odv <= 1'b0;
                    timer <= 3'b101;
                end
                3'b101:
                begin
                    ce_out <= 1'b0;
                    odv <= 1'b0;
                    timer <= 3'b110;
                end
                3'b110:
                begin
                    ce_out <= 1'b0;
                    odv <= 1'b0;
                    timer <= 3'b111;
                end
                3'b111:
                begin
                    ce_out <= 1'b0;
                    odv <= 1'b1;
                    timer <= 3'b000;
                end
                default:
                begin
                    ce_out <= 1'b0;
                    odv <= 1'b0;
                    timer <= 3'b000;
                end
            endcase
        end
        else        //chip is disabled
        begin
            ce_out <= 1'b0;
            odv <= 1'b0;
        end
    end



    genvar j;

    assign in_bufctrl = (rw_in && ce_in);       //buffer only when rw_in=1 and ce_in=1
    assign out_bufctrl = (~rw_out && ce_in);     //buffer only when rw_out=0 and ce_in=1

    //data direction buffers for inout
    generate
    for(j = 0; j < d_width; j = j+1)
    begin:buffers
        bufif1 RW_BUF_IN (data_in[j], data_in_reg[j], in_bufctrl);
        bufif1 RW_BUF_OUT (data_out[j], data_out_reg[j], out_bufctrl);
    end
    endgenerate

endmodule
