//John Wright
//Danny Peters
//University of Kentucky EE480 DV Project
//Spring 2011
//
//Main execution file for 'assembler'
//
//Usage:
//
//     assembler [-[d][v]] [outputfile] inputfile

#define USAGE "assembler [-[d][v]] [outputfile] inputfile"

using namespace std;

#include <stdio.h>
#include <iostream>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "assembler.tab.h"

extern int yyparse();
extern FILE* yyin;
FILE* outfile;
FILE* debugout;
bool flag_debug;
bool flag_verbose;

int main(int argc, char** argv) {
    
    flag_debug = false;
    flag_verbose = false;
    
    if(argc == 2) {
        //no options
        yyin = fopen(argv[1],"r");
        outfile = fopen("out.bin","w");
        
    } else if(argc == 3) {
        //one option
        if(strcmp(argv[1],"-d") == 0) {
            //enable debug output
            flag_debug = true;
            debugout = fopen("out_debug.txt","w");
            yyin = fopen(argv[2],"r");
            outfile = fopen("out.bin","w");
        
        } else if(strcmp(argv[1],"-dv") == 0) {
            //enable verbose and debug output
            flag_verbose = true;
            flag_debug = true;
            debugout = fopen("out_debug.txt","w");
            yyin = fopen(argv[2],"r");
            outfile = fopen("out.bin","w");
            
        } else if(strcmp(argv[1],"-v") == 0) {
            //enable verbose output
            flag_verbose = true;
            yyin = fopen(argv[2],"r");
            outfile = fopen("out.bin","w");
            
        } else {
            //output to specific file
            yyin = fopen(argv[2],"r");
            outfile = fopen(argv[1],"w");
            
        }
        
    } else if(argc == 4) {
        //one option and specific file
        if(strcmp(argv[1],"-d") == 0) {
            //enable debug output
            flag_debug = true;
            debugout = fopen("out_debug.txt","w");
            yyin = fopen(argv[3],"r");
            outfile = fopen(argv[2],"w");
        
        } else if(strcmp(argv[1],"-dv") == 0) {
            //enable verbose and debug output
            flag_verbose = true;
            flag_debug = true;
            debugout = fopen("out_debug.txt","w");
            yyin = fopen(argv[3],"r");
            outfile = fopen(argv[2],"w");
            
        } else if(strcmp(argv[1],"-v") == 0) {
            //enable verbose output
            flag_verbose = true;
            yyin = fopen(argv[3],"r");
            outfile = fopen(argv[2],"w");
            
        } else {
            //usage error
            cout << "Usage:" << endl;
            cout << "     " << USAGE << endl;
            exit(0);
            
        }
        
    } else {
        //usage error
        cout << "Usage:" << endl;
        cout << "     " << USAGE << endl;
        exit(0);
    }

    yyparse();
    fclose(yyin);
    fclose(outfile);
    if(flag_debug)
        fclose(debugout);
    
}