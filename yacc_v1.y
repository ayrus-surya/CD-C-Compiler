%{
 #include<stdio.h>
 int valid=1;
int yylex();
int yyerror(const char *s);
extern int st[100];
extern int top;
extern int count;
extern void display();
%}


%start main_block
//%start RHS

%token declaration identifier unary operator number assignmentop comparisionop logicalop while_x for_x if_x main_x
%left '+' '-'
%left '/' '*'
%left '%'

%%

main_block : declaration main_x '(' ')'  body 
	;
	
body : '{' multiple_expressions '}' body
     | assignment_expression
     | '{' '}'
     | if
     | for
     | while
     ;


if: if_x '(' extended_logical_expression ')' body
    ;
	
for : for_x '(' assignment_expression_with_null ';' extended_logical_expression_with_null ';' extended_logical_expression_with_null ')' body
	;
      
while :  while_x '(' logical_expression ')' body
       | while_x '(' expression ')' body       
       ;

extended_logical_expression_with_null:extended_logical_expression
				    | 
				    ;
assignment_expression_with_null:assignment_expression
				| 
				;

multiple_expressions: logical_expression ';' multiple_expressions 
		    | expression ';' multiple_expressions 
	        | body
	            ;  


logical_expression: comparision_expression logicalop extended_logical_expression
		   | assignment_expression logicalop extended_logical_expression
		   | RHS logicalop extended_logical_expression
		   ;
 
extended_logical_expression:logical_expression
			  | comparision_expression
		          | assignment_expression
		          | RHS
		          ;

expression:  comparision_expression 
	   | assignment_expression
           | declaration_statement
	   | RHS
	   ;

comparision_expression:RHS comparisionop RHS
		      ;

assignment_expression: declaration_statement assignmentop RHS
		     | identifier assignmentop RHS
                     ;

declaration_statement: declaration identifier        
    		     | declaration_statement ',' pointers identifier 
    		     ;

pointers : pointers '*'  
	|
	;

RHS: '(' RHS ')' 
    | RHS '+' RHS
    | RHS '-' RHS
    | RHS '/' RHS
    | RHS '*' RHS
    | RHS '%' RHS 
    | F
    ;

F: identifier 
    | '*' identifier
    | '&' identifier
    | '~' identifier
    | '!' identifier
    | identifier unary
    | unary identifier
    | number
    ;

%%

#include <ctype.h>
int yyerror(const char *s)
{
  	extern int yylineno;
  	valid =0;
  	printf("Line no: %d \n The error is: %s\n",yylineno,s);
}

int main(){
	st[0]=0;
	top=0;
	count=0;
	yyparse();
	if(valid==1)
		printf("Valid\n");
	else
		printf("Invalid\n");
	display();

}

