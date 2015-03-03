#include <stdio.h>
#include <string.h>
#include "symtable.h"

struct symbol_table sym_table;
int top=-1,count=1,count1=0,x=0;


void initialize()
{
	int i=0;
	while(i < MAX_HASH_SIZE){
		sym_table.front[i]=NULL;
		i++;
	}
}


int keywd_id(char name[],char datatype[])
{
	if(count==1){
		initialize();
	}
	int i,key=0,k=0,j=0,s=0;	
	while(name[j]!='\0'){
		s=name[j];
		k=k+s;
		j++;
	}
	key=k%TABLE_SIZE;
    j=search(sym_table.front[key],name);
	if(x==0){
		j=insert(name,datatype,key);
	}
	return j;		
}

int hwc_insert(char name[],char datatype[],int key)
{
	struct symbol *new_symbol=NULL,*node_ref=NULL;
	node_ref=sym_table.front[key];
	if(node_ref==NULL){
		
		new_symbol=createNode(name,datatype);
		sym_table.front[key]=new_symbol;		
		return new_symbol->id; 
	}
	else{
		while(node_ref->next!=NULL){ 
			if(!strcmp(node_ref->name,name)){
				return node_ref->id;
			}
			else{
				node_ref=node_ref->next;
			}			
		}		
		if(node_ref->next==NULL){	
			new_symbol=createNode(name,datatype);
			node_ref->next=new_symbol;
			return new_symbol->id;
		}
	}
}	

struct symbol *createNode(char name[],char datatype[])
{
	struct symbol *new=NULL;
	new=(struct symbol *)malloc(sizeof(struct symbol));
    strcpy(new->name,name);
	strcpy(new->datatype,datatype);
	if(!strcmp(datatype,"int")){
		new->location=count1;
		count1=count1+sizeof(int);
	}
	if(!strcmp(datatype,"float")){
		new->location=count1;
		count1=count1+sizeof(float);
	}
	if(!strcmp(datatype,"char")){
		new->location=count1;
		count1=count1+sizeof(char);
	}
	if(!strcmp(datatype,"double")){
		new->location=count1;
		count1=count1+sizeof(double);
	}
	new->id=count;
	count++;
	new->next=NULL;
	return (new);
}

int hwc_search(struct symbol *ptr,char name[])
{
	if(ptr==NULL){
		x=0;
		return 0;
	}
	else{
		while(ptr!=NULL){
			if(!strcmp(ptr->name,c)){
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


	