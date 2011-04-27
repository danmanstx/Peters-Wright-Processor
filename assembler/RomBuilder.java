//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//RomBuilder.java
//
//A utility that will convert a file of ASCII '0' and '1' characters from
//the assembler utility into a verilog ROM module.
//
//Usage:
//
//  java RomBuilder infile [d_width a_width]
//

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.StringTokenizer;

public class RomBuilder {

    public static final String USAGE = 
        "Usage:\n    java RomBuilder [-w d_width a_width] infile0 [infile1 ...]";

    public static final String FILEHEAD =
        "`timescale 1ns / 1ps\n" +
        "///////////////////////////////////////////////////////////////////////////////////////\n" +
        "//John Wright & Danny Peters\n" +
        "//University of Kentucky\n" +
        "//EE480 Spring 2011\n" +
        "//DV Final Project\n" +
        "//\n" +
        "//RAM_<name>.v\n" +
        "//\n" +
        "//An auto-generated ROM module implemented as a RAM.  Generated using the RomBuilder\n" +
        "//tool.\n" +
        "//\n" +
        "///////////////////////////////////////////////////////////////////////////////////////\n";

    public static final String FILEMID0 = 
        "    input [a_width-1:0] addr;           //address (m bits wide)\n" +
        "    input ce;                           //chip enable (func. when ce=1, HiZ when ce=0)\n" +
        "    input clk;                          //posedge clock\n" +
        "    input clr;                          //synch active low clear\n" +
        "    input rw;                           //read when rw=1 write when rw=0\n" +
        "    inout [d_width-1:0] data;           //data in/out bus\n" +
        "    reg [d_width-1:0] data_out_reg;     //data output register\n" +
        "    reg [d_width-1:0] memory [2**a_width-1:0];  //memory values\n" +
        "    wire bufctrl;                               //buffer control\n" +
        "    \n";
    
    public static final String FILEMID1 =
        "    //read/write synchronous loop\n" +
        "    always@(posedge clk)\n" +
        "    begin\n" +
        "        if(clr == 0)        //clear contents\n" +
        "        begin\n" +
        "            data_out_reg <= 0;\n";

    public static final String FILEEND =
        "        end\n" +
        "        if(ce == 1)         //only read or write if chip is enabled\n" +
        "        begin\n" +
        "            if(clr == 1)    //do nothing on a clear\n" +
        "            begin\n" +
        "                if(rw == 0) //write data\n" +
        "                begin\n" +
        "                    memory[addr] <= data;\n" +
        "                end\n" +
        "                else        //read data\n" +
        "                begin\n" +
        "                    data_out_reg <= memory[addr];\n" +
        "                end\n" +
        "            end\n" +
        "        end\n" +
        "    end\n" +
        "    \n" +
        "    genvar j;\n" +
        "    \n" +
        "    assign bufctrl = (rw && ce);    //buffer only when rw=1 and ce=1 (read and chip enabled)\n" +
        "    \n" +
        "    //data direction buffers for inout\n" +
        "    generate\n" +
        "    for(j = 0; j < d_width; j = j+1)\n" +
        "    begin:buffers\n" +
        "        bufif1 RW_BUF    (data[j],data_out_reg[j],bufctrl);\n" +
        "    end\n" +
        "    endgenerate\n" +
        "\n" +
        "endmodule\n";

    private static int d_width;
    private static int a_width;
    private static int memlocs;
    private static String moduleName;
    private static StringTokenizer tokenizer;
    private static FileWriter writer;
    private static ArrayList<File> inFiles;
    private static File outFile;
    private static int[][] data;

    public static void main(String [] args) {

        inFiles = new ArrayList<File>();
        if( args.length == 0 ) {
            System.err.println( USAGE );
            System.exit(1);
        }
        if( args[0].equals("-w") ) {
            if( args.length < 4 ) {
                System.err.println( USAGE );
                System.exit(1);
            }
            try {
                d_width = Integer.parseInt(args[1]);
                a_width = Integer.parseInt(args[2]);
            }
            catch( NumberFormatException e ) {
                System.err.println( USAGE );
                System.exit(1);
            }
            //get other files
            for( int i = 3; i < args.length; i += 1 )
                inFiles.add( new File( args[i] ) );
        }
        else {
            d_width = 16;   //default to 16
            a_width = 8;    //default to 8
            for( int i = 0; i < args.length; i += 1 )
                inFiles.add( new File( args[i] ) );
        }

        memlocs = 1;
        for( int i = 0; i < a_width; i += 1 )
            memlocs *= 2;

        data = new int[memlocs][d_width];

        tokenizer = new StringTokenizer( inFiles.get(0).getName() );
        moduleName = "RAM_" + tokenizer.nextToken(".");

        try {
            outFile = new File( moduleName + ".v" );
            writer = new FileWriter( outFile );
            for( File f : inFiles )
                scanInFile(f);
        }
        catch( IOException e ) {
            System.err.println( e.getMessage() );
            System.exit(1);
        }

        try {

            writer.write( FILEHEAD );

            writer.write(
                "module " + moduleName + "(addr, ce, clk, clr, rw, data);\n" +
                "    parameter d_width = " + d_width + ";              //data bus width\n" +
                "    parameter a_width = " + a_width + ";              //address width (2**m memory locations)\n"
                );

            writer.write( FILEMID0 );
            writer.write( "    initial\n    begin\n" );

            for( int i = 0; i < memlocs; i += 1 ) {
                writer.write( "        memory[" + i + "] = " + d_width + "\'b" );
                for( int j = 0; j < d_width; j += 1 ) {
                    writer.write( "" + data[i][j] );
                }
                writer.write( ";\n" );
            }

            writer.write( "    end\n\n" );
            writer.write( FILEMID1 );

            for( int i = 0; i < memlocs; i += 1 ) {
                writer.write( "            memory[" + i + "] <= " + d_width + "\'b" );
                for( int j = 0; j < d_width; j += 1 ) {
                    writer.write( "" + data[i][j] );
                }
                writer.write( ";\n" );
            }

            writer.write( FILEEND );

            writer.close();

        }
        catch( IOException e ) {
            System.err.println( "Error writing file." );
        }

    }

    public static void scanInFile(File file) throws IOException {
        FileReader reader = new FileReader(file);
        int a = 0;
        int d = 0;
        try {
            while( reader.ready() ) {
                char c = (char)reader.read();
                if( c == '@' ) {
                    int i = 0;
                    if( d != 0 )
                        throw new IOException( "Error at symbol @ on line: " + a );
                    if( !reader.ready() )
                        throw new IOException( "Unexpected EOF" );
                    c = (char)reader.read();
                    while( c != '\n' ) {
                        if( !reader.ready() )
                            throw new IOException( "Unexpected EOF" );
                        if( !Character.isDigit(c) )
                            throw new IOException( "Unexpected character: " + c + " on line: " + a );
                        i = 10*i + Character.digit( c, 10 );
                        c = (char)reader.read();
                    }
                    a = i;
                } else if(c == '0') {
                    data[a][d++] = 0;
                } else if(c == '1') {
                    data[a][d++] = 1;
                } else if(c == '\n') {
                    a += 1;
                    d = 0;
                } else
                    throw new IOException( "Error in input file.  Unrecognized character: " +
                            c + " on line: " + a );
            }
        }
        catch( NullPointerException e ) {
            reader.close();
            throw new IOException( "Error in input file.  Too many characters on line: " + a );
        }
        reader.close();
    }
}
