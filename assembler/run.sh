#!/bin/bash
#########################################################
#John Wright & Danny Peters
#University of Kentucky
#EE480 Spring 2011
#DV Final Project
###########################################################
set isr0at="@200"
set isr1at="@210"
set isr2at="@220"
set isr3at="@230"
echo "assembling interrupt service routines..."
./assembler z.bin isrs/z.txt
./assembler v.bin isrs/v.txt
./assembler opcode.bin isrs/opcode.txt
./assembler ext_int.bin isrs/ext_int.txt
echo $isr0at > isrcode/isr0
cat v.bin >> isrcode/isr0
echo $isr1at > isrcode/isr1
cat v.bin >> isrcode/isr1
echo $isr2at > isrcode/isr2
cat v.bin >> isrcode/isr2
echo $isr3at > isrcode/isr3
cat v.bin >> isrcode/isr3

echo "building test program: interrupts..."
./assembler -mi interrupts.asm testprogs/interrupts.txt
echo "building test program: subroutine..."
./assembler -mi subroutine.asm testprogs/subroutine.txt
echo "building test program: bubblesort..."
./assembler -mi bubblesort.asm testprogs/bubblesort.txt
echo "building test program: straightflow..."
./assembler -mi straightflow.asm testprogs/straightflow.txt
echo "building test program: fibonacci..."
./assembler -mi fibonacci.asm testprogs/fibonacci.txt
mv *.v ../verilog

