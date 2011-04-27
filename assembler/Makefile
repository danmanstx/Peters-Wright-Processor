# Makefile
# John Wright
# Danny Peters
# University of Kentucky EE480 DV Project
# Assembler

OBJS = assembler.tab.o lex.yy.o main.o
CC = g++
CFLAGS = -g -Wno-write-strings -Wno-deprecated -ansi -pedantic

all: assembler rom_builder testprogs/*.txt
	bash run.sh

rom_builder: RomBuilder.java
	javac RomBuilder.java

assembler: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o assembler -lfl
	
lex.yy.o: lex.yy.c
	$(CC) $(CFLAGS) -c lex.yy.c -o lex.yy.o

lex.yy.c: assembler.l assembler.tab.h
	flex assembler.l
	
assembler.tab.o: assembler.tab.c
	$(CC) $(CFLAGS) -c assembler.tab.c -o assembler.tab.o

assembler.tab.c: assembler.y
	bison -d -v assembler.y

main.o: main.cc
	$(CC) $(CFLAGS) -c main.cc -o main.o

lex.yy.o main.o: assembler.tab.h

clean:
	rm -f *.o *.class *.v *.bin *.txt *.asm *~ lex.yy.c assembler.tab.c assembler.tab.h assembler.output assembler testprogs/*~ isrcode/*

