#!/bin/bash
#########################################################
#John Wright & Danny Peters
#University of Kentucky
#EE480 Spring 2011
#DV Final Project
###########################################################
echo "assembling interrupt service routines..."
./assembler z.bin isrs/z.txt
./assembler v.bin isrs/v.txt
./assembler opcode.bin isrs/opcode.txt
./assembler ext_int.bin isrs/ext_int.txt
echo "@200" > isrcode/isr0
cat z.bin >> isrcode/isr0
echo "@210" > isrcode/isr1
cat v.bin >> isrcode/isr1
echo "@220" > isrcode/isr2
cat opcode.bin >> isrcode/isr2
echo "@230" > isrcode/isr3
cat ext_int.bin >> isrcode/isr3

echo "building test program: test..."
./assembler -mi test.asm testprogs/test.txt
mv out_debug.txt test_debug.txt
echo "building test program: interrupts..."
./assembler -mi interrupts.asm testprogs/interrupts.txt
mv out_debug.txt interrupts_debug.txt
echo "building test program: subroutine..."
./assembler -mi subroutine.asm testprogs/subroutine.txt
mv out_debug.txt subroutine_debug.txt
echo "building test program: bubblesort..."
./assembler -mi bubblesort.asm testprogs/bubblesort.txt
mv out_debug.txt bubblesort_debug.txt
echo "building test program: straightflow..."
./assembler -mi straightflow.asm testprogs/straightflow.txt
mv out_debug.txt straightflow_debug.txt
echo "building test program: fibonacci..."
./assembler -mi fibonacci.asm testprogs/fibonacci.txt
mv out_debug.txt fibonacci_debug.txt
mv *.v ../verilog

