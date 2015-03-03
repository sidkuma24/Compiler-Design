%{
	#include<stdio.h>
	#include<string.h>
%}

 
delim [ \t\n]
ws {delim}+
letter [a-zA-Z]
digit [0-9]
number {digit}+
alpha [a-zA-Z0-9_]

%%

{ws} ;

if	printf("IF");
else	printf("ELSE");
while	printf("WHILE");
for	printf("FOR");
break	printf("BREAK");
continue	printf("CONTINUE");
return	printf("RETURN");
auto	printf("AUTO");
case	printf("CASE");
char	{printf("CHAR");strcpy(type,"char");}
const	printf("CONST");
default	printf("DEFAULT");
do	{printf("DO");strcpy(type,"do");}
double	{printf("DOUBLE");strcpy(type,"double");}
enum	{printf("ENUM");}
extern	{printf("EXTERN");}
float	{printf("FLOAT");strcpy(type,"float");}
goto	{printf("GOTO");}
int	{printf("INT");strcpy(type,"int");}
long	{printf("LONG");strcpy(type,"long");}
register	{printf("REGISTER");}
short	{printf("SHORT");}
signed	{printf("SIGNED");}
sizeof	{printf("SIZEOF");}
static	{printf("STATIC");}
struct	{printf("STRUCT");}
switch	{printf("SWITCH");}
typedef	{printf("TYPEDEF");}
union	{printf("UNION");}
unsigned	{printf("UNSIGNED");}
void	{printf("VOID");}
volatile	{printf("VOLATILE");}
contents	{display();}

"<" {printf("LT");}
"<=" {printf("LE");}
">" {printf("GT");}
">=" {printf("GE");}
"==" {printf("EQ");}
"!=" {printf("NE");}
"!"	{printf("NOT");}
"=" {printf("ASSIGNED_TO");}
"+=" {printf("PLUS_EQ");}
"-=" {printf("MINUS_EQ");}
"*=" {printf("MULT_EQ");}
"/=" {printf("DIV_EQ");}
"%=" {printf("MOD_EQ");}

"+" printf("PLUS");
"-" printf("MINUS");
"*" printf("MULT");
"/" printf("DIV");
"%" printf("MOD");
";" printf("<;>");
"," printf("<,>");
"(" printf("<(>");
")" printf("<)>");
"[" printf("<[>");
"]" printf("<]>");


{letter}{alpha}* {yylval.id = (char)* strdup(yytext);
                  return (ID);}

{number} { return (NUMBER);}

%%



main()
{
	FILE *f=NULL;
	f=fopen("./commands.txt","r");
	yyin=f;
	yylex();
}

			
				
yywrap()
{

}













