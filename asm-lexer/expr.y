%{

#include <stdio.h>
#include <string.h>
#include <expr.h>

%}

%union {
	int ival;
	unsigned long lval;
	struct symtab *sym;
}
%token <ival> SYMBOL
%token <ival> REG
%token <ival> NUMBER
%left '-' '+'
%left '*' '/' '%'
%left '&' '|' '^'
%nonassoc UMINUS UCOMPL UASTRX
%type <ival> expression

%%
statement: 	SYMBOL '=' expression	{printf("%d = %d\n", $1, $3); }
	| 			expression 					{printf("= %d\n", $1); }
	;

expression:	expression '+' expression		{ $$ = $1 + $3; }
	|			expression '-' expression 		{ $$ = $1 - $3; }
	|			expression '*' expression 		{ $$ = $1 * $3; }
	|			expression '/' expression 		{ if ($3) $$ = $1 / $3; }
	|			expression '%' expression 		{ $$ = $1 % $3; }
	|			expression '&' expression 		{ $$ = $1 & $3; }
	|			expression '|' expression 		{ $$ = $1 | $3; }
	|			expression '^' expression 		{ $$ = $1 ^ $3; }
	|			'-' expression	%prec UMINUS 	{ $$ = -$2; }
	|			'~' expression	%prec UCOMPL 	{ $$ = ~$2; }
	|			'*' expression	%prec UASTRX 	{ $$ = $2; 	/* deref */ }	
	|			'(' expression ')' 				{ $$ = $2; }
	|			'#''[' expression ']' 			{ $$ = $3;  /* deref */ }
	|			NUMBER								{ $$ = $1; }
	|			SYMBOL  								{ $$ = $1; }
	|			REG     								{ $$ = $1; }
	;

%%
extern FILE *yyin;
main() {
	do yyparse(); while(! feof(yyin) );
}
yyerror(char *s){ 
	fprintf(stderr, "shit! %s\n", s);
}
