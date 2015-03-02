%{
	#include<stdio.h>
	#include<string.h>
	#define TABLE_SIZE 100
	#define ID_SIZE 20
	int keywd_id(char arr[],char x[]);
	struct node *createnode(char c[],char d[]);
	int insert(char b[],char d[],int c);
	void display();
	void initialize();
	char type[10];
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


{letter}{alpha}* printf("<ID%d>",keywd_id(yytext,type));

{number} printf("<NUMBER%s>",yytext);

%%

int top=-1,count=1,count1=0,x=0;
struct node
{
	char symbolTable[10];
	int id;
	int location;
	char datatype[10];
	struct node *next;
};

struct node1
{
	struct node *front[100];
}first;

void initialize()
{
	int i=0;
	while(i<100)
	{
		first.front[i]=NULL;
		i++;
	}
}

main()
{
	FILE *f=NULL;
	f=fopen("./commands.txt","r");
	yyin=f;
	yylex();
}

int keywd_id(char arr[],char b[])
{
	if(count==1)
	{
		initialize();
	}
	int i,key=0,k=0,j=0,s=0;	
	while(arr[j]!='\0')
	{
		s=arr[j];
		k=k+s;
		j++;
	}
	key=k%TABLE_SIZE;
	j=search(first.front[key],arr);
	if(x==0)
	{
		j=insert(arr,b,key);
	}
	return j;		
}

int insert(char b[],char d[],int c)
{
	struct node *ptr=NULL,*a=NULL;
	a=first.front[c];
	if(a==NULL)
	{
		
		ptr=createnode(b,d);
		first.front[c]=ptr;		
		return ptr->id; 
	}
	else
	{
		while(a->next!=NULL)
		{ 
			if(!strcmp(a->symbolTable,b))
			{
				return a->id;
			}
			else
			{
				a=a->next;
			}			
		}		
		if(a->next==NULL)
		{	
			ptr=createnode(b,d);
			a->next=ptr;
			return ptr->id;
		}
	}
}	

struct node *createnode(char c[],char d[])
{
	struct node *ptr=NULL;
	ptr=(struct node *)malloc(sizeof(struct node));
	strcpy(ptr->symbolTable,c);
	strcpy(ptr->datatype,d);
	if(!strcmp(d,"int"))
	{
		ptr->location=count1;
		count1=count1+4;
	}
	if(!strcmp(d,"float"))
	{
		ptr->location=count1;
		count1=count1+4;
	}
	if(!strcmp(d,"char"))
	{
		ptr->location=count1;
		count1=count1+1;
	}
	if(!strcmp(d,"double"))
	{
		ptr->location=count1;
		count1=count1+8;
	}
	ptr->id=count;
	count++;
	ptr->next=NULL;
	return ptr;
}

void display()
{
	int i=0;
	struct node *ptr=NULL;
	
	while(i<TABLE_SIZE){
		ptr=first.front[i];
		while(ptr!=NULL){
			printf("\n identifier datatype: %s, identifier name: %s, id: %d, identifier memory location: %d ",ptr->datatype,ptr->symbolTable,ptr->id,ptr->location);
			ptr=ptr->next;			
		}
		i++;
	}
}

int search(struct node *ptr,char c[])
{
	if(ptr==NULL){
		x=0;
		return 0;
	}
	else{
		while(ptr!=NULL){
			if(!strcmp(ptr->symbolTable,c)){
				x=1;
				return ptr->id;
			}
			else{
				x=0;
				ptr=ptr->next;
			}
		}
	}
}
				
				
yywrap()
{

}













