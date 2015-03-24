

parser: scanner.l parser.y
	    bison -d parser.y
	    flex scanner.l
	    cc -o $@ parser.tab.c lex.yy.c -lfl
