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
extern FILE* debugfile;
extern bool flag_debug;
extern bool flag_verbose;
extern string line_toprint;
string debug_string = "";
char debug_temp[512];
int addr = 0;
bool two_word = false;
bool flag_error = false;        //error flag.  Do not generate ouput if true
bool flag_label = false;
bool flag_label_call = false;

struct label {
    char name[16];
    int addr;
    bool declared;
    int instances[16];
    bool is_six[16];
    long debug_ptrs[16];
    int cnt;
};

//only support 32 unique labels
struct label labels[32];
int labelcount = 0;
label *lastlabel;

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
    if(val > 255 || val < -128) {
        yyerror_nonfatal("invalid immediate");
        buf = "00000000";
        return;
    }
    
    bool neg = false;
    
    if(val >= 128) {
        //unsigned positive
        val -= 128;
        buf[0] = '1';
    } else if(val < 0) {
        //negative
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
//Label functions
//---------------------------------------------------------------------------

//create a label
void label_create(char* name, int address) {
    //Max 15 chars long
    if(strlen(name) == 0 || strlen(name) > 15) {
        yyerror("invalid label");
        //exits
    }
    for(int i = 0; i < labelcount; i++) {
        if(strcmp(labels[i].name,name) == 0) {
            if(labels[i].declared) {
                //already exists, exit
                yyerror("label redeclaration");
            }
            else {
                labels[i].declared = true;
                labels[i].addr = address;
                return;
            }
        }
    }
    if(labelcount > 31) {
        //exit
        yyerror("too many labels (max 32)");
    }
    strcpy(labels[labelcount].name,name);
    labels[labelcount].declared = true;
    labels[labelcount].addr = address;
    labels[labelcount].cnt = 0;
    labelcount += 1;
    return;
}

//reference a label
void label_check(char* name, int address, bool is_six) {
    if(strlen(name) == 0 || strlen(name) > 15) {
        yyerror("invalid label");
        //exits
    }
    for(int i = 0; i < labelcount; i++) {
        if(strcmp(labels[i].name,name) == 0) {
            if(labels[i].declared) {
                //label declared
                if(labels[i].cnt > 15) {
                    yyerror("too many references to label (max 16)");
                    //exits
                }
                labels[i].is_six[labels[i].cnt] = is_six;
                labels[i].instances[labels[i].cnt] = address;
                labels[i].cnt = labels[i].cnt + 1;
                lastlabel = &(labels[i]);
                return;
            }
            
        }
    }
    if(labelcount > 31) {
        //exit
        yyerror("too many labels (max 32)");
    }
    strcpy(labels[labelcount].name,name);
    labels[labelcount].declared = false;
    labels[labelcount].cnt = 1;
    labels[labelcount].instances[0] = address;
    labels[labelcount].is_six[0] = is_six;
    lastlabel = &(labels[labelcount]);
    labelcount += 1;
    return;
}

//replace label placeholder
void label_replace(string& s, int labelno, int count) {
    int offset = labels[labelno].addr - labels[labelno].instances[count];
    //check if 16 bit
    if(labels[labelno].is_six[count]) {
        if(offset > 31 || offset < -32) {
            yyerror_nonfatal("branch distance too large");
            return;
        }
        //convert offset to string in buffer
        char buf[7];
        opr_conv_6(offset,buf);
        buf[6] = '\0';
        //copy buffer to s
        s.insert((17 * (labels[labelno].instances[count])) + 10,buf);
        s.erase((17 * (labels[labelno].instances[count])) + 16,6);
        if(flag_debug || flag_verbose) {
            debug_string.insert(labels[labelno].debug_ptrs[count] - 9,buf);
            debug_string.erase(labels[labelno].debug_ptrs[count] - 3,6);
        }
    }
    else {
        //absolute address, not relative
        offset = labels[labelno].addr;
        if(offset > 255 || offset < 0) {
            yyerror_nonfatal("invalid jump");
            return;
        }
        //convert offset to string in buffer
        char buf[9];
        offset = labels[labelno].addr;
        opr_conv_8(offset,buf);
        buf[8] = '\0';
        //copy buffer to s
        s.insert((17 * (labels[labelno].instances[count])) + 6,buf);
        s.erase((17 * (labels[labelno].instances[count])) + 14,8);
        if(flag_debug || flag_verbose) {
            debug_string.insert(labels[labelno].debug_ptrs[count] - 13,buf);
            debug_string.erase(labels[labelno].debug_ptrs[count] - 5,8);
        }      
    }
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
#define OP_MOV     "1001"
#define OP_LDR     "101000"
#define OP_LDI     "101001"
#define OP_STR     "101010"
#define OP_LMR     "101011"
#define OP_IN      "101100"
#define OP_OUT     "101101"

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
%token LDI
%token LMR
%token IN
%token OUT


%%

program:            instructions EF {
                        //manage labels
                        for(int i = 0; i < labelcount; i += 1) {
                            for(int j = 0; j < labels[i].cnt; j += 1) {
                                label_replace($1,i,j);
                            }
                        }
                        if(!flag_error) {
                            fprintf(outfile,$1.c_str());
                        }
                        if(flag_debug) {
                            fprintf(debugfile,debug_string.c_str());
                        }
                        if(flag_verbose) {
                            printf(debug_string.c_str());
                        }
                        return 0;
                    };

instructions:       instructions instruction_ {
                        $$ = $1 + $2;
                    } | {/*nullable*/};
                    
instruction_:       instruction END {
                        $$ = $1;
                        if(flag_debug || flag_verbose) {
                            sprintf(debug_temp,("@%02Xh\n%d     " + line_toprint + "\n" +
                                $1 + "\n\n").c_str(),addr,yylineno-1);
                            debug_string += debug_temp;
                            if(flag_label_call) {
                                lastlabel->debug_ptrs[lastlabel->cnt-1] = debug_string.size();
                                flag_label_call = false;
                            }
                        }
                        if(flag_label) {
                            flag_label = false;
                        }
                        else if(two_word) {
                            addr += 2;
                            two_word = false;
                        }
                        else {
                            addr += 1;
                        }
                        
                    } |
                    
                    END {
                        $$ = "";
                    };
                    
instruction:        AND alu_opr {
                        $$ = OP_AND + $2 + "\n";
                    } |
                    
                    ADD alu_opr {
                        $$ = OP_ADD + $2 + "\n";
                    } |
                    
                    SUB alu_opr {
                        $$ = OP_SUB + $2 + "\n";
                    } |
                    
                    OR alu_opr {
                        $$ = OP_OR + $2 + "\n";
                    } |
                    
                    NOT alu_opr {
                        $$ = OP_NOT + $2 + "\n";
                    } |
                    
                    LSL alu_opr {
                        $$ = OP_LSL + $2 + "\n";
                    } |
                    
                    LSR alu_opr {
                        $$ = OP_LSR + $2 + "\n";
                    } |
                    
                    BNE br_opr {
                        $$ = OP_BNE + $2 + "\n";
                    } |
                    
                    BLT br_opr {
                        $$ = OP_BLT + $2 + "\n";
                    } |
                    
                    JMP '#' num_8 {
                        $$ = OP_JMP + $3 + "00\n";
                    } |
                    
                    JMP LBL {
                        //label jump
                        label_check(yytext,addr,false);
                        flag_label_call = true;
                        $$ = OP_JMP + string("--------00\n");
                    } |
                    
                    CALL '#' num_8 {
                        $$ = OP_CALL + $3 + "00\n";
                    } |
                    
                    CALL LBL {
                        //label call
                        label_check(yytext,addr,false);
                        flag_label_call = true;
                        $$ = OP_CALL + string("--------00\n");
                    } |
                    
                    RTS {
                        $$ = OP_RTS + string("0000000000\n");
                    } |
                    
                    ISR {
                        $$ = OP_ISR + string("0000000000\n");
                    } |
                    
                    MOV mov_opr {
                        $$ = OP_MOV + $2 + "\n";
                    } |
                    
                    LDR num_4 ',' '#' num_8{
                        two_word = true;
                        $$ = OP_LDR + $2 + "000000\n" + $5 + "00000000\n";
                    } |
                    
                    LDI num_4 ',' '#' num_8{
                        two_word = true;
                        $$ = OP_LDI + $2 + "000000\n" + $5 + "00000000\n";
                    } |
                    
                    STR num_4 ',' '#' num_8{
                        two_word = true;
                        $$ = OP_STR + $2 + "000000\n" + $5 + "00000000\n";
                    } |
                    
                    LMR '#' num_4 {
                        $$ = OP_LMR + $3 + "000000\n";
                    } |
                    
                    IN num_4 {
                        $$ = OP_IN + $2 + "000000\n";
                    } |
                    
                    OUT num_4 {
                        $$ = OP_OUT + $2 + "000000\n";
                    } |
                    
                    num_16 {
                        //manually enter instructions
                        $$ = $1 + "\n";
                    } |
                    
                    LBL {
                        //label declaration
                        label_create(yytext,addr);
                        flag_label = true;
                    } ':' ;
                    
alu_opr:            num_4 ',' num_4 {
                        //direct addressing mode
                        $$ = "00" + $1 + $3 + "00";
                    } |
                    
                    num_4 ',' '#' num_8 {
                        //immediate addressing mode
                        two_word = true;
                        $$ = "01" + $1 + "000000\n" + $4 + "00000000";
                    } |
                    
                    num_4 ',' '(' num_4 ')' {
                        //register indirect addressing mode
                        $$ = "10" + $1 + $4 + "00";
                    } |
                    
                    num_4 ',' '#' num_8 '(' num_4 ')' {
                        //displacement addressing mode
                        two_word = true;
                        $$ = "11" + $1 + $6 + "00\n" + $4 + "00000000";
                    };

br_opr:             num_4 ',' num_6 {
                        //direct addressing mode
                        $$ = "0" + $1 + $3;
                    } |
                    
                    '(' num_4 ')' ',' num_6 {
                        //register indirect addressing mode
                        $$ = "1" + $2 + $5;
                    } |
                    
                    num_4 ',' LBL {
                        //direct addressing w/ label
                        label_check(yytext,addr,true);
                        flag_label_call = true;
                        $$ = "0" + $1 + "------";
                    } |
                    
                    '(' num_4 ')' ',' LBL {
                        //reg. indirect w/ label
                        label_check(yytext,addr,true);
                        flag_label_call = true;
                        $$ = "1" + $2 + "------";
                    };

mov_opr:            num_4 ',' num_4 {
                        //direct addressing mode
                        $$ = "00" + $1 + $3 + "00";
                    } |
                    
                    num_4 ',' '(' num_4 ')' {
                        //register indirect to register addressing mode
                        $$ = "01" + $1 + $4 + "00";
                    } |
                    
                    '(' num_4 ')' ',' num_4 {
                        //register to register indirect addressing mode
                        $$ = "10" + $2 + $5 + "00";
                    } |
                    
                    '(' num_4 ')' ',' '(' num_4 ')' {
                        //register indirect to register indirect addressing mode
                        $$ = "11" + $2 + $6 + "00";
                    };

num_4:              DEC {
                        char buf[5];
                        buf[4] = '\0';
                        int val = strtol(yytext,NULL,10);
                        opr_conv_4(val,buf);
                        $$ = string(buf);   
                    } |
                    
                    HEX {
                        char buf[5];
                        buf[4] = '\0';
                        int val = strtol(yytext+1,NULL,16);
                        opr_conv_4(val,buf);
                        $$ = string(buf);  
                    };

num_6:              DEC {
                        char buf[7];
                        buf[6] = '\0';
                        int val = strtol(yytext,NULL,10);
                        opr_conv_6(val,buf);
                        $$ = string(buf);
                    } |
                    
                    HEX {
                        char buf[7];
                        int val = strtol(yytext+1,NULL,16);
                        opr_conv_6(val,buf);
                        $$ = string(buf);
                    };
                    
num_8:              DEC {
                        char buf[9];
                        buf[8] = '\0';
                        int val = strtol(yytext,NULL,10);
                        opr_conv_8(val,buf);
                        $$ = string(buf);
                    } |
                    
                    HEX {
                        char buf[9];
                        buf[8] = '\0';
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
