

%{
/**
 * Siddharth Kumar <kumar.siddharth450@gmail.com>
 * 6th semester compiler lab assignment
 *
 * parser.y input file for bison.
**/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define TABLESIZE 1000
#define M 997

struct st_node
{
    char* var_name;
	char* type;
    int key;
    struct st_node* next;
};

typedef struct st_node st_node;
st_node T[TABLESIZE];
st_node* insert(char*);
st_node* getsym(char*);
void printtab();

int type1=0;

void yyerror(char *s); 
%}

%union {
    int iValue;
    char* in;
};

%token IDENTIFIER CONSTANT STRING_LITERAL SIZEOF
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME

%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELLIPSIS

%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%start translation_unit

%type <in> IDENTIFIER

%error-verbose
%%

primary_expression
	: IDENTIFIER 	
	| CONSTANT
	| STRING_LITERAL
	| '(' expression ')'
	;

postfix_expression
	: primary_expression
	| postfix_expression '[' expression ']'
	| postfix_expression '(' ')'
	| postfix_expression '(' argument_expression_list ')'
	| postfix_expression '.' IDENTIFIER
	| postfix_expression PTR_OP IDENTIFIER
	| postfix_expression INC_OP
	| postfix_expression DEC_OP
	;

argument_expression_list
	: assignment_expression
	| argument_expression_list ',' assignment_expression
	;

unary_expression
	: postfix_expression
	| INC_OP unary_expression
	| DEC_OP unary_expression
	| unary_operator cast_expression
	| SIZEOF unary_expression
	| SIZEOF '(' type_name ')'
	;

unary_operator
	: '&'
	| '*'
	| '+'
	| '-'
	| '~'
	| '!'
	;

cast_expression
	: unary_expression
	| '(' type_name ')' cast_expression
	;

multiplicative_expression
	: cast_expression
	| multiplicative_expression '*' cast_expression
	| multiplicative_expression '/' cast_expression
	| multiplicative_expression '%' cast_expression
	;

additive_expression
	: multiplicative_expression
	| additive_expression '+' multiplicative_expression
	| additive_expression '-' multiplicative_expression
	;

shift_expression
	: additive_expression
	| shift_expression LEFT_OP additive_expression
	| shift_expression RIGHT_OP additive_expression
	;

relational_expression
	: shift_expression
	| relational_expression '<' shift_expression
	| relational_expression '>' shift_expression
	| relational_expression LE_OP shift_expression
	| relational_expression GE_OP shift_expression
	;

equality_expression
	: relational_expression
	| equality_expression EQ_OP relational_expression
	| equality_expression NE_OP relational_expression
	;

and_expression
	: equality_expression
	| and_expression '&' equality_expression
	;

exclusive_or_expression
	: and_expression
	| exclusive_or_expression '^' and_expression
	;

inclusive_or_expression
	: exclusive_or_expression
	| inclusive_or_expression '|' exclusive_or_expression
	;

logical_and_expression
	: inclusive_or_expression
	| logical_and_expression AND_OP inclusive_or_expression
	;

logical_or_expression
	: logical_and_expression
	| logical_or_expression OR_OP logical_and_expression
	;

conditional_expression
	: logical_or_expression
	| logical_or_expression '?' expression ':' conditional_expression
	;

assignment_expression
	: conditional_expression
	| unary_expression assignment_operator assignment_expression
	;

assignment_operator
	: '='
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| ADD_ASSIGN
	| SUB_ASSIGN
	| LEFT_ASSIGN
	| RIGHT_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

expression
	: assignment_expression
	| expression ',' assignment_expression
	;

constant_expression
	: conditional_expression
	;

declaration
	: declaration_specifiers ';'	{type1 = 0;}
	| declaration_specifiers init_declarator_list ';' {type1 = 0;}
	;

declaration_specifiers
	: storage_class_specifier
	| storage_class_specifier declaration_specifiers
	| type_specifier
	| type_specifier declaration_specifiers
	| type_qualifier
	| type_qualifier declaration_specifiers
	;

init_declarator_list
	: init_declarator
	| init_declarator_list ',' init_declarator
	;

init_declarator
	: declarator
	| declarator '=' initializer
	;

storage_class_specifier
	: TYPEDEF
	| EXTERN
	| STATIC
	| AUTO
	| REGISTER
	;

type_specifier
	: VOID	{type1=8;}
	| CHAR	{type1=9;}
	| SHORT	{type1=1;}
	| INT	{type1=2;}
	| LONG	{type1=3;}
	| FLOAT	{type1=4;}
	| DOUBLE	{type1=5;}
	| SIGNED	{type1=6;}
	| UNSIGNED	{type1=7;}
	| struct_or_union_specifier
	| enum_specifier
	| TYPE_NAME
	;

struct_or_union_specifier
	: struct_or_union IDENTIFIER '{' struct_declaration_list '}'
	| struct_or_union '{' struct_declaration_list '}'
	| struct_or_union IDENTIFIER
	;

struct_or_union
	: STRUCT
	| UNION
	;

struct_declaration_list
	: struct_declaration
	| struct_declaration_list struct_declaration
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list ';'
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list
	| type_specifier
	| type_qualifier specifier_qualifier_list
	| type_qualifier
	;

struct_declarator_list
	: struct_declarator
	| struct_declarator_list ',' struct_declarator
	;

struct_declarator
	: declarator
	| ':' constant_expression
	| declarator ':' constant_expression
	;

enum_specifier
	: ENUM '{' enumerator_list '}'
	| ENUM IDENTIFIER '{' enumerator_list '}'
	| ENUM IDENTIFIER
	;

enumerator_list
	: enumerator
	| enumerator_list ',' enumerator
	;

enumerator
	: IDENTIFIER
	| IDENTIFIER '=' constant_expression
	;

type_qualifier
	: CONST
	| VOLATILE
	;

declarator
	: pointer direct_declarator
	| direct_declarator
	;

direct_declarator
	: IDENTIFIER	{/*printf("in yacc %s\n",$1);*/	insert($1);}
	| '(' declarator ')'
	| direct_declarator '[' constant_expression ']'
	| direct_declarator '[' ']'
	| direct_declarator '(' parameter_type_list ')'
	| direct_declarator '(' identifier_list ')'
	| direct_declarator '(' ')'
	;

pointer
	: '*'
	| '*' type_qualifier_list
	| '*' pointer
	| '*' type_qualifier_list pointer
	;

type_qualifier_list
	: type_qualifier
	| type_qualifier_list type_qualifier
	;


parameter_type_list
	: parameter_list
	| parameter_list ',' ELLIPSIS
	;

parameter_list
	: parameter_declaration
	| parameter_list ',' parameter_declaration
	;

parameter_declaration
	: declaration_specifiers declarator
	| declaration_specifiers abstract_declarator
	| declaration_specifiers
	;

identifier_list
	: IDENTIFIER	{/*printf("in yacc %s \n",$1);*/	insert($1);}
	| identifier_list ',' IDENTIFIER {/*printf("in yacc %s \n",$3);*/	insert($3);}
	;

type_name
	: specifier_qualifier_list
	| specifier_qualifier_list abstract_declarator
	;

abstract_declarator
	: pointer
	| direct_abstract_declarator
	| pointer direct_abstract_declarator
	;

direct_abstract_declarator
	: '(' abstract_declarator ')'
	| '[' ']'
	| '[' constant_expression ']'
	| direct_abstract_declarator '[' ']'
	| direct_abstract_declarator '[' constant_expression ']'
	| '(' ')'
	| '(' parameter_type_list ')'
	| direct_abstract_declarator '(' ')'
	| direct_abstract_declarator '(' parameter_type_list ')'
	;

initializer
	: assignment_expression
	| '{' initializer_list '}'
	| '{' initializer_list ',' '}'
	;

initializer_list
	: initializer
	| initializer_list ',' initializer
	;

statement
	: labeled_statement
	| compound_statement
	| expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	;

labeled_statement
	: IDENTIFIER ':' statement
	| CASE constant_expression ':' statement
	| DEFAULT ':' statement
	;

compound_statement
	: '{' '}'
	| '{' statement_list '}'
	| '{' declaration_list '}'
	| '{' declaration_list statement_list '}'
	;

declaration_list
	: declaration
	| declaration_list declaration
	;

statement_list
	: statement
	| statement_list statement
	;

expression_statement
	: ';'
	| expression ';'
	;

selection_statement
	: IF '(' expression ')' statement
	| IF '(' expression ')' statement ELSE statement
	| SWITCH '(' expression ')' statement
	;

iteration_statement
	: WHILE '(' expression ')' statement
	| DO statement WHILE '(' expression ')' ';'
	| FOR '(' expression_statement expression_statement ')' statement
	| FOR '(' expression_statement expression_statement expression ')' statement
	;

jump_statement
	: GOTO IDENTIFIER ';'
	| CONTINUE ';'
	| BREAK ';'
	| RETURN ';'
	| RETURN expression ';'
	;

translation_unit
	: external_declaration
	| translation_unit external_declaration
	;

external_declaration
	: function_definition
	| declaration
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement
	| declaration_specifiers declarator compound_statement
	| declarator declaration_list compound_statement
	| declarator compound_statement
	;

%%

extern char yytext[];
extern int column;
extern FILE* yyin;

int main(int argc, char* argv[])
{
	int i;
	for(i=0;i<TABLESIZE;i++)
	{
	  T[i].var_name = NULL;
	  T[i].type = NULL;
	  T[i].key = 0;
	  T[i].next = NULL;
	}
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
	i = yyparse();
	printf("parse returns %d\n",i);
	printtab();
	return 0;
}

st_node* insert(char* inp)
{
	int key=0, index, j, n;
	st_node* search = (st_node*)malloc(sizeof(st_node));
	n=strlen(inp);
	//printf("identifier %s\n",inp);
	for(j=0;j<n;j++)
	{
		key+=inp[j];
	}
	index=key%M;
	search=&(T[index]);
	if(search->var_name!=NULL)
	{
		while(search->next != NULL)
		{
			search = search->next;
		}
		search->next = (st_node*)malloc(sizeof(st_node));
		search = search->next;
	}
	search->var_name=(char*)malloc(sizeof(char)*(strlen(inp)+1));
	search->type=(char*)malloc(sizeof(char)*10);
	strcpy(search->var_name,inp);
	search->key=key;
	search->next=NULL;
	if(type1==1)
	  strcpy(search->type,"short");
	else if(type1==2)
	  strcpy(search->type,"int");
	else if(type1==3)
	  strcpy(search->type,"long");
	else if(type1==4)
	  strcpy(search->type,"float");
	else if(type1==5)
	  strcpy(search->type,"double");
	else if(type1==6)
	  strcpy(search->type,"signed");
	else if(type1==7)
	  strcpy(search->type,"unsigned");
	else if(type1==8)
	  strcpy(search->type,"void");
	else if(type1==9)
	  strcpy(search->type,"char");  
	return search;
}

st_node* getsym(char* inp)
{
	int key, index, j, n;
	st_node* search = (st_node*)malloc(sizeof(st_node));
	n=strlen(inp);
	for(j=0;j<n;j++)
	{
		key+=inp[j];
	}
	index=key%M;
	search=&(T[index]);
	while( search->var_name != NULL )
	{
		if(!strcmp(search->var_name,inp))
			return search;
		search = search->next;
	}
	return NULL;
}

void printtab()
{
	int j;
	FILE *fp=fopen("symtab.txt","w");
	st_node* search = (st_node*)malloc(sizeof(st_node));
	printf("***************SYMBOL-TABLE***************\n");
	fprintf(fp,"***************SYMBOL-TABLE***************\n");
	for(j=0;j<TABLESIZE;j++)
	{
		if(T[j].var_name != NULL)
		{
			fprintf(fp,"%d. %s %s %d %p",j,T[j].var_name,T[j].type,T[j].key,&(T[j]));
			printf("%d. %s %s %d %p",j,T[j].var_name,T[j].type,T[j].key,&(T[j]));
			search=T[j].next;
			while(search!=NULL)
			{
				fprintf(fp,"-->%s %d %p",search->var_name,search->key,search);
				printf("--> %s %d %p",search->var_name,search->key,search);
				search=search->next;
			}
			fprintf(fp,"\n");
			printf("\n");
		}
	}
}

void yyerror(char *s) 
{
	printf("error called %s\n",s);
}
