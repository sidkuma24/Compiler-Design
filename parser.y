%{
   #include <stdio.h>
   #inlcude <stdlib.hd>
   #include "symtable.h"

%}


%union{
	struct symbol *s;
    double d;

}

/* declaration of tokens */
%token IF ELSE WHILE FOR BREAK CONTINUE RETURN AUTO CASE CHAR
%token CONST DEFAULT DO DOUBLE ENUM EXTERN FLOAT GOTO INT LONG 
%token REGISTER SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF
%token UNION UNSIGNED VOID VOLATILE
%token <d> NUMBER
%token <s> IDENTIFIER

