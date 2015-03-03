
#define MAX_HASH_SIZE 9997

extern int yylineno; /* from the lexer */
void yyerror(char *s,...);

/*symbol table functions */
void initialize();
int keywd_id(char name[],char datatype[]);
struct symbol *createNode(char name[],char datatype[]);
int hwc_insert(char neame[],char datatype[],int key);
int hwc_search(struct symbol *ptr,char name[])
void display();

extern char type[10];

/*symbol table */

struct symbol
{
	char name[20];
	int id;
	int location;
	char datatype[10];
	double value;
	struct node *next;
};

struct symbol_table
{
	struct symbol *front[MAX_HASH_SIZE];
};






