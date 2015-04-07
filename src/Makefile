#Makefile for c compiler "mycc"

all: mycc

mycc:	parser.y scanner.l 
	bison -d parser.y && \
	flex scanner.l && \
	gcc -g -o $@ parser.tab.c lex.yy.c -lm -lfl

clean:
	rm -f parser.tab.c parser.tab.h \
	lex.yy.c *.o *~ bison flex funcs mycc
