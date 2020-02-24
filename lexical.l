%option yylineno
%{
#include"y.tab.h"
#include<stdio.h>
int st[100];
int top;
int count;
int o_scope;
int up;
int sc_set;
int set;
int in;
void insertIntoSym(char *text,int nm,int scp);
void display();
%}

%%
^"#include".+ ;
main					    {printf("main\n");      return main_x;}
if 					    {printf("if\n");        return if_x;}
while 					    {printf("while\n");     return while_x;}
for 					    {set=1;printf("for\n");	    return for_x;}
printf						{printf("printf\n");	return printf_x;}
([&][&])|([|][|])                               { printf("logicalop:%s\n",yytext); return logicalop;}
([+][=])|([-][=])|([*][=])|([/][=])|([%][=])|([=]) {in=0;printf("assignop:%s\n",yytext); return assignmentop;}
([=][=])|([>])|([<])|([!][=])|([>][=])|[<]([=]) {in=0;printf("compop:%s\n",yytext); return comparisionop;}
((int)|(float)|(double)|(char))[* ]*  {if(set==1){sc_set=1;o_scope++;}in=1;printf("decl:%s\n",yytext); return declaration;}
[0-9][0-9]*		{set=0;in=0;printf("num:%s\n",yytext); return number;}
([+][+])|([-][-]) {set=0;in=0;printf("unary:%s\n",yytext);return unary;}
[A-Za-z_]([A-Za-z0-9_])* {if(in==1){set=0;insertIntoSym(yytext,yylineno,st[top]);}in=0;printf("id:%s\n",yytext); return identifier;}
\n*			     ;
[\t ]*	;
\{		{if(sc_set){o_scope--;sc_set=0;}o_scope++;return yytext[0];}
\}		{o_scope--; return yytext[0];}
(\/\/.*)|"/*"([^*]|(\*+[^*/]))*\*+\/[\n]* ;
.	{return yytext[0];}

%%

struct scope
{
	char arr[20];
	int scope2;
};

struct scope symtab[100];


void insertIntoSym(char *text,int nm,int scp)
{
	int present=0;
	for(int i=0;i<=up;i++)
	{
		if(strcmp(symtab[i].arr,text)==0 && symtab[i].scope2==o_scope)
		{
			present=1;
			break;
		}
	}
	if(present==0)
	{
		strcpy(symtab[up].arr,text);
		symtab[up].scope2=o_scope;
		up++;
	}
}

void display()
{
	printf("\nSymbol Table\n");
	printf("Symbol\t\tScope\n");
	for(int i=0;i<up;i++)
	{
		printf("%s\t\t%d\n",symtab[i].arr,symtab[i].scope2);
	}	
}
int yywrap()
{
return 1;
}
