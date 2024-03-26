############################################################################
#
# file: Makefile
#
# @Author:   Athanasios Ioannis Xanthopoulos && Zafeiris Panagiwtis Kanakis
# @Version:  23-02-2024
# @email:    csd4702@csd.uoc.gr && csd4891@csd.uoc.gr
#
# Makefile
#
############################################################################
CC = gcc
CFLAGS = -g

all: calc

calc: scanner.c list.o stack.o parser.c symtable.o scope_list.o
	$(CC) $(CFLAGS) $^ -o $@

scanner.c: lex.l
	flex --outfile=scanner.c lex.l

parser.c: yacc.y
	bison --yac -d --output parser.c yacc.y -v

symtable.o: symtable.c
	$(CC) $(CFLAGS) -c $<

scope_list.o: scope_list.c
	$(CC) $(CFLAGS) -c $<

list.o: list.c symtable.h
	$(CC) $(CFLAGS) -c $<

stack.o: stack.c stack.h
	$(CC) $(CFLAGS) -c $<

clean:
	@-rm -f *.out *.o *.exe
	@-rm -f scanner.c parser.c parser.h lex.yy.c calc