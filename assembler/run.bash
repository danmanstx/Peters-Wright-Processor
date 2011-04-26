#!/bin/bash
echo "building interrupts"
./assembler -mi interrupts testprogs/interrupts.txt
echo "building subroutine"
./assembler -mi subroutine testprogs/subroutine.txt
echo "building bubblesort"
./assembler -mi bubblesort testprogs/bubblesort.txt
echo "building straightflow"
./assembler -mi straightflow testprogs/straightflow.txt
rm interrupts subroutine bubblesort straightflow
mv *.v ../verilog

