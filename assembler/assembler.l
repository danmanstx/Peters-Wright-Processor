%{
//John Wright
//Danny Peters
//University of Kentucky EE480 DV Project
//Spring 2011
//
//Flex lexer file for 'assembler'
using namespace std;

#include <stdio.h>
#include <iostream>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "assembler.tab.h"

extern int yyerror(char *err);      //print error messages to cerr
string line = "";                   //line buffer for debugging output
string line_toprint = "";           //line data returned to parser

#define YY_NO_UNPUT


%}

b       [01]
d		[0-9]
bin     "%"{b}+
dec		(-)?{d}+
hex     "$"[0-9a-fA-F]+
lbl		[a-zA-Z][_a-zA-Z0-9]*

I_LINE_COMMENT "\""([^\n])*

%%
{I_LINE_COMMENT}    {line += yytext; }

"and"               {line += yytext; return AND; }
"add"               {line += yytext; return ADD; }
"sub"               {line += yytext; return SUB; }
"or"                {line += yytext; return OR; }
"not"               {line += yytext; return NOT; }
"lsl"               {line += yytext; return LSL; }
"lsr"               {line += yytext; return LSR; }
"bne"               {line += yytext; return BNE; }
"blt"               {line += yytext; return BLT; }
"jmp"               {line += yytext; return JMP; }
"call"              {line += yytext; return CALL; }
"rts"               {line += yytext; return RTS; }
"isr"               {line += yytext; return ISR; }
"mov"               {line += yytext; return MOV; }
"ldr"               {line += yytext; return LDR; }
"str"               {line += yytext; return STR; }
"lmr"               {line += yytext; return LMR; }
"in"                {line += yytext; return IN; }
"out"               {line += yytext; return OUT; }

{lbl}               {line += yytext; return LBL; }
{bin}               {line += yytext; return BIN; }
{dec}               {line += yytext; return DEC; }
{hex}               {line += yytext; return HEX; }
"-"                 {line += yytext; return '-'; }
"#"			        {line += yytext; return '#'; }
"("	    	        {line += yytext; return '('; }
")"                 {line += yytext; return ')'; }
","                 {line += yytext; return ','; }
":"                 {line += yytext; return ':'; }
[ \t]*		        {line += yytext; }
[\n]		        {
                        line_toprint = line;
                        line = "";
                        yylineno += 1;
                        return END;
                    }
                    
<<EOF>>             {return EF; }

.                   {yyerror("unrecognized symbol");}
