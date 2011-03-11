%{
//John Wright
//Danny Peters
//University of Kentucky EE480 DV Project
//Spring 2011
//
//Bison parser file for 'assembler'

#include <stdio.h>
#include <iostream>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

using namespace std;
//---------------------------------------------------------------------------
//Externals from assembler
//---------------------------------------------------------------------------

extern int yylex(void);
extern int yylineno;
extern char *yytext;
extern FILE* outfile;
extern FILE* debugout;
extern bool flag_debug;
extern bool flag_verbose;
extern string line_toprint;

bool flag_error = false;        //error flag.  Do not generate ouput if true

//error function
int yyerror(char *msg)
{
    flag_error = true;
    cerr << "ERROR: " << msg << " at symbol \"" << yytext << "\" on line " << 
        yylineno << endl;
    exit(1);
}

//non fatal error function
void yyerror_nonfatal(char *msg)
{
    flag_error = true;
    cerr << "ERROR: " << msg << " at symbol \"" << yytext << "\" on line " << 
        yylineno << endl;
    return;
}

//---------------------------------------------------------------------------
//Formatting Functions
//---------------------------------------------------------------------------

//print 4-bit binary numbers
void opr_conv_4(int val, char* buf) {
    if(val > 15 || val < 0) {
        yyerror_nonfatal("invalid register");
        buf = "0000";
        return;
    }
    
    for(int i = 3; i >= 0; i -= 1) {
        if(val >= (1 << i)) {
            val -= (1 << i);
            buf[3-i] = '1';
        }
        else {
            buf[3-i] = '0';
        }
    }
    return;
}

//print 6-bit binary numbers
void opr_conv_6(int val, char* buf) {
    if(val > 31 || val < -32) {
        yyerror_nonfatal("invalid immediate");
        buf = "000000";
        return;
    }
    
    bool neg = false;
    
    if(val < 0) {
        neg = true;
        val = abs(val) - 1;
        buf[0] = '1';
    }
    else {
        buf[0] = '0';
    }
    
    for(int i = 4; i >= 0; i -= 1) {
        if(val >= (1 << i)) {
            val -= (1 << i);
            if(neg)
                buf[5-i] = '0';
            else
                buf[5-i] = '1';
        }
        else {
            if(neg)
                buf[5-i] = '1';
            else
                buf[5-i] = '0';
        }
    }
    return;
}

//print 8-bit binary numbers
void opr_conv_8(int val, char* buf) {
    if(val > 127 || val < -128) {
        yyerror_nonfatal("invalid immediate");
        buf = "00000000";
        return;
    }
    
    bool neg = false;
    
    if(val < 0) {
        neg = true;
        val = abs(val) - 1;
        buf[0] = '1';
    }
    else {
        buf[0] = '0';
    }
    
    for(int i = 6; i >= 0; i -= 1) {
        if(val >= (1 << i)) {
            val -= (1 << i);
            if(neg)
                buf[7-i] = '0';
            else
                buf[7-i] = '1';
        }
        else {
            if(neg)
                buf[7-i] = '1';
            else
                buf[7-i] = '0';
        }
    }
    return;
}

//---------------------------------------------------------------------------
//Opcode definitions
//---------------------------------------------------------------------------

#define OP_AND     "0000"
#define OP_ADD     "0001"
#define OP_SUB     "0010"
#define OP_OR      "0011"
#define OP_NOT     "0100"
#define OP_LSL     "0101"
#define OP_LSR     "0110"
#define OP_BNE     "01110"
#define OP_BLT     "01111"
#define OP_JMP     "100000"
#define OP_CALL    "100001"
#define OP_RTS     "100010"
#define OP_ISR     "100011"
#define OP_MOV     "10010"
#define OP_LDR     "100110"
#define OP_STR     "100111"
#define OP_LMR     "101000"
#define OP_IN      "101001"
#define OP_OUT     "101010"

//---------------------------------------------------------------------------
//Other definitions
//---------------------------------------------------------------------------

#define YYSTYPE string


%}

%token BIN
%token DEC
%token END
%token EF
%token HEX
%token LBL

%token AND
%token ADD
%token SUB
%token OR
%token NOT
%token LSL
%token LSR
%token BNE
%token BLT
%token JMP
%token CALL
%token RTS
%token ISR
%token MOV
%token LDR
%token STR
%token LMR
%token IN
%token OUT


%%

program:            instructions {
                        if(!flag_error) {
                            fprintf(outfile,$1.c_str());
                        }
                        return 0;
                    };

instructions:       instructions instruction_ {
                        $$ = $1 + $2;
                    } | {/*nullable*/};
                    
instruction_:       instruction END {
                        $$ = $1 + "\n";
                        if(flag_debug) {
                            fprintf(debugout,("%d     " + line_toprint + "\n" + $1 + "\n\n").c_str(),yylineno-1);
                        }
                        if(flag_verbose) {
                            printf(("%d     " + line_toprint + "\n" + $1 + "\n\n").c_str(),yylineno-1);
                        }
                    } |
                    
                    END {
                        $$ = "\n";
                    };
                    
instruction:        AND alu_opr {
                        $$ = OP_AND + $2;
                    } |
                    
                    ADD alu_opr {
                        $$ = OP_ADD + $2;
                    } |
                    
                    SUB alu_opr {
                        $$ = OP_SUB + $2;
                    } |
                    
                    OR alu_opr {
                        $$ = OP_OR + $2;
                    } |
                    
                    NOT alu_opr {
                        $$ = OP_NOT + $2;
                    } |
                    
                    LSL alu_opr {
                        $$ = OP_LSL + $2;
                    } |
                    
                    LSR alu_opr {
                        $$ = OP_LSR + $2;
                    } |
                    
                    BNE br_opr {
                        $$ = OP_BNE + $2;
                    } |
                    
                    BLT br_opr {
                        $$ = OP_BLT + $2;
                    } |
                    
                    JMP '#' num_8 {
                        $$ = OP_JMP + $2 + "00";
                    } |
                    
                    CALL {
                    
                    } |
                    
                    RTS {

                    } |
                    
                    ISR {

                    } |
                    
                    MOV mov_opr {
                    
                    } |
                    
                    LDR {
                    
                    } |
                    
                    STR {
                    
                    } |
                    
                    LMR {
                    
                    } |
                    
                    IN {
                    
                    } |
                    
                    OUT {
                    
                    } |
                    
                    num_16 {
                        //manually enter instructions
                        $$ = $1;
                    };
                    
alu_opr:            num_4 ',' num_4 {
                        //direct addressing mode
                        $$ = "00" + $1 + $3 + "00";
                    } |
                    
                    num_4 ',' '#' num_8 {
                        //immediate addressing mode
                        $$ = "11" + $1 + "000000\n" + $4 + "00000000";
                    } |
                    
                    num_4 ',' '(' num_4 ')' {
                        //register indirect addressing mode
                        $$ = "10" + $1 + $4 + "00";
                    } |
                    
                    num_4 ',' num_4 '(' num_8 ')' {
                        //displacement addressing mode
                        $$ = "11" + $1 + $3 + "00\n" + $5 + "00000000";
                    };

br_opr:             num_4 ',' num_6 {
                        //direct addressing mode
                        $$ = "0" + $1 + $3;
                    } |
                    
                    '(' num_4 ')' ',' num_6 {
                        //register indirect addressing mode
                        $$ = "1" + $1 + $3;
                    };

mov_opr:            num_4 ',' num_4 {
                        //direct addressing mode
                        $$ = "0" + $1 + $3 + "00";
                    } |
                    
                    num_4 ',' '(' num_4 ')' {
                        //register indirect addressing mode
                        $$ = "1" + $1 + $3 + "00";
                    };

num_4:              DEC {
                        char buf[4];
                        int val = strtol(yytext,NULL,10);
                        opr_conv_4(val,buf);
                        $$ = string(buf);   
                    } |
                    
                    HEX {
                        char buf[4];
                        int val = strtol(yytext+1,NULL,16);
                        opr_conv_4(val,buf);
                        $$ = string(buf);  
                    };

num_6:              DEC {
                        char buf[6];
                        int val = strtol(yytext,NULL,10);
                        opr_conv_6(val,buf);
                        $$ = string(buf);
                    } |
                    
                    HEX {
                        char buf[6];
                        int val = strtol(yytext+1,NULL,16);
                        opr_conv_6(val,buf);
                        $$ = string(buf);
                    };
                    
num_8:              DEC {
                        char buf[8];
                        int val = strtol(yytext,NULL,10);
                        opr_conv_8(val,buf);
                        $$ = string(buf);
                    } |
                    
                    HEX {
                        char buf[8];
                        int val = strtol(yytext+1,NULL,16);
                        opr_conv_8(val,buf);                        
                        $$ = string(buf);
                    };
                    
num_16:             BIN {
                        if(strlen(yytext+1) != 16) {
                            yyerror_nonfatal("invalid binary");
                            $$ = string("0000000000000000");
                        }
                        else {
                            $$ = string(yytext+1);
                        }
                    };                    
                    
                    
%%