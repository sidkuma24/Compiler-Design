%{
	#include"value.h"
	#include"parser.tab.h"
	#define TABLE_SIZE 20
	#define ID_SIZE 20
	#define ERROR 9999999
%}

delim [ \t\n]
ws {delim}+
letter [a-zA-Z]
digit [0-9]
number {digit}+
alpha [a-zA-Z0-9_]
identifier {letter}{alpha}* 

%%

{ws} ;

if	return IF;
else	return ELSE;
while	return WHILE;
for	return FOR;
break	return BREAK;
continue	return CONTINUE;
return	return RETURN;
case	return CASE;
char	return CHAR;
const	return CONST;
default	return DEFAULT;
do	return DO;
double	return DOUBLE;
float	return FLOAT;
int	return INT;
long	return LONG;
short	return SHORT;

{identifier} {strcpy(yylval.id_name,yytext); return IDENTIFIER;}
{number}	{strcpy(yylval.id_name,yytext); return NUMBER;}
. return *yytext;


%%

yywrap(){
	return 1;
}

