%{
	#include<stdio.h>
	#include<string.h>
	#include<stdlib.h>
	#define TABLE_SIZE 20
	#define ID_SIZE 20
	#define SYMBOL_TABLE_OVERFLOW -1
	#define UNDECLARED -2
	#define REDECLARATION -3
	#define DECLARATION 0
	#define USAGE 1
	int type_flag;
	//static unsigned short error_count = 0;
	char *new_temp_var();
   
	typedef struct{
		char code[1000];
		char place[20];
	}value;
	
	 
%}

%union{
	char id_name[20];
	value temp;
}

%token IF ELSE WHILE FOR BREAK CONTINUE RETURN CASE CHAR CONST DEFAULT DO DOUBLE FLOAT INT LONG SHORT
%token <id_name> IDENTIFIER NUMBER

  
%start program
%type<temp> exp assignment
%left '+' '-' 
%left '*' '/'

%%

program: statement
		|
		program statement
{
  //printf("\nIntermediate 3-address code:\n\n");
}
;

statement: declaration
		|
		assignment
;

declaration: declaration_specifiers ';'
;

declaration_specifiers: datatype idlist
;

datatype: INT	{type_flag=INT;}
		|
		FLOAT	{type_flag=FLOAT;}
		|
		CHAR	{type_flag=CHAR;}
;

idlist: idlist ',' IDENTIFIER  
		{
		 	if(check_symtab_entry($3,type_flag,DECLARATION)==REDECLARATION){
		 	
		 		printf("Error: Redeclaration of variable %s\n",$3);
		 		return 0;
		 	} 
		}
		|
		IDENTIFIER 
		{ 
			if(check_symtab_entry($1,type_flag,DECLARATION)==REDECLARATION){
				
				printf("Error: Redeclaration of variable %s\n",$1);
				return 0;
			}
		}
;

assignment:	IDENTIFIER '=' exp ';'
{
	strcpy($$.code, $3.code);
	strcat($$.code, $1);
	strcat($$.code, ":=" );
	strcat($$.code, $3.place);
	strcat($$.code, "\n");
	
	printf("\n%s\n",$$.code);
}
;

exp: IDENTIFIER	
	{
		if(check_symtab_entry($1, NULL, USAGE)==UNDECLARED){
			
			printf("Error: Undeclared identifier %s\n",$1);
			return 0;
		}
		else{ 
			strcpy($$.place,$1);
			strcpy($$.code,"");
		}
	}
	|
	NUMBER
	{
		strcpy($$.place,$1);
		strcpy($$.code,"");
	}
;

exp: exp '+' exp 
{
	strcpy($$.place,new_temp_var()); 
	strcpy($$.code,$1.code);
	strcat($$.code,$3.code);
	strcat($$.code,$$.place);
	strcat($$.code,":=");
	strcat($$.code,$1.place);
	strcat($$.code,"+");
	strcat($$.code,$3.place);
	strcat($$.code, "\n");	
} 
;

exp: exp '-' exp
{
	strcpy($$.place,new_temp_var()); 
	strcpy($$.code,$1.code);
	strcat($$.code,$3.code);
	strcat($$.code,$$.place);
	strcat($$.code,":=");
	strcat($$.code,$1.place);
	strcat($$.code,"-");
	strcat($$.code,$3.place);
	strcat($$.code, "\n");
}
;

exp: exp '*' exp
{
	strcpy($$.place,new_temp_var()); 
	strcpy($$.code,$1.code);
	strcat($$.code,$3.code);
	strcat($$.code,$$.place);
	strcat($$.code,":=");
	strcat($$.code,$1.place);
	strcat($$.code,"*");
	strcat($$.code,$3.place);
	strcat($$.code, "\n");
}
;

exp: exp '/' exp
{
	strcpy($$.place,new_temp_var()); 
	strcpy($$.code,$1.code);
	strcat($$.code,$3.code);
	strcat($$.code,$$.place);
	strcat($$.code,":=");
	strcat($$.code,$1.place);
	strcat($$.code,"/");
	strcat($$.code,$3.place);
	strcat($$.code, "\n");
}
;

exp: '(' exp ')'
{
	strcpy($$.place,$2.place); 
	strcpy($$.code,$2.code);	
}
;


%%

int id_count=0;

typedef struct{
	char s[ID_SIZE];
	char type[10];
	int index;
	
}symbol;

symbol *symbolTable[TABLE_SIZE];
extern FILE* yyin;

int main(int argc, char *argv[]){

	int i, parser_return; 
	
	for(i=0; i<TABLE_SIZE; i++)	
                 symbolTable[i]=NULL;
	if(argc < 2)
	{
		printf("ERROR: Not enough arguments\n");
		exit(0);
	}
	yyin = fopen(argv[1],"r");
	if(!yyin)
	{
		printf("ERROR: Unable to open source code\n");
		exit(0);
	}
        
	parser_return = yyparse();
	printf("parser returned: %d",parser_return);
        printf("\n\n--------------------------------------------------\n");
	printf("                  Symbol Table\n");
        printf("--------------------------------------------------\n");

	for(i=0; i<TABLE_SIZE; i++){
	     if(symbolTable[i]==NULL){
		      //printf("%d: (null)\n",i);
	     }
		 else printf("%d: %s  ID%d  type:%s\n", i,symbolTable[i]->s,symbolTable[i]->index,symbolTable[i]->type);
	}
	printf("\n");
	
	return 0;
}
char *new_temp_var(){

	static int i=1;
	char *temp;
	temp=(char*)malloc(10);
	sprintf(temp,"T%d",i++);
	return temp;
}


int check_symtab_entry(char arr[],int typeFlag,int status){	//status=DECLARATION or USAGE 

	int i=h(arr), j=0;
	char type[10];

	
	switch(typeFlag){
		case INT: strcpy(type,"int");
				break;
		case FLOAT: strcpy(type,"float");
				break;
		case CHAR: strcpy(type,"char");
				break;
	}
	
	do{
	
		if(symbolTable[(i+j)%TABLE_SIZE]==NULL){
		
			if(status==USAGE){	
                            return UNDECLARED;			
		        }
			symbolTable[(i+j)%TABLE_SIZE]=(symbol*)malloc(sizeof(symbol));
			strcpy( symbolTable[(i+j)%TABLE_SIZE]->s, arr);
			symbolTable[(i+j)%TABLE_SIZE]->index=id_count++;
			strcpy( symbolTable[(i+j)%TABLE_SIZE]->type, type);
			
			return id_count-1;	
		}		
	
		if(!strcmp(arr, symbolTable[ (i+j)%TABLE_SIZE ]->s)){
		
			if(status==DECLARATION)	return REDECLARATION;
			return symbolTable[ (i+j)%TABLE_SIZE ]->index;
		}
		j++;
	}while(j<TABLE_SIZE);
	return SYMBOL_TABLE_OVERFLOW;
} 

int h(char id[]){

	int i, c=0;
	for(i=0; id[i]; i++)	
             c+=id[i];
	
        return (c%TABLE_SIZE);
}


yyerror(char *error_msg)
{
	printf("\n%s\n",error_msg);
}


