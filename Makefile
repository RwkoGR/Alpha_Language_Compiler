
###################################################
#
# file: Makefile
#
# @Author:   Athanasios Ioannis Xanthopoulos && Zafeiris Panagiwtis Kanakis
# @Version:  23-02-2024
# @email:    csd4702@csd.uoc.gr && csd4891@csd.uoc.gr
#
# Makefile
#
####################################################
CC = gcc
CFLAGS = -g

all: a.out

a.out: lex.yy.c list.o stack.o
	$(CC) $(CFLAGS) $^ -o $@

lex.yy.c: lex.l
	lex lex.l

list.o: list.c
	$(CC) $(CFLAGS) -c $<

stack.o: stack.c
	$(CC) $(CFLAGS) -c $<

clean:
	@-rm -f *.out *.o *.exe
	@-rm -f lex.yy.c