%{
#include <string.h>
#include "y.tab.h"
#include "expr.h"
struct symtab symtable[256];
struct symtab regtable[23] = {
	{ "EAX", 1 }, { "EBX", 2 }, { "ECX", 3 }, { "EDX", 4 },
	{ "EBP", 5 }, { "ESP", 6 }, { "EDI", 7 }, { "ESI", 8 },
	{ "ESI", 9 }, { "EIP", 10 }, { "CS", 11 }, { "DS", 12 },
	{ "ES", 13 }, { "FS", 14 }, { "GS", 15 }, { "ZF", 16 },
	{ "PF", 17 }, { "CF", 18 }, { "OF", 19 }, { "AF", 20 },
	{ "SF", 21 }, { "IF", 22 }, { "DF", 23 }
};
%}

%%
[1-9][0-9]*			{ yylval.ival = atoi(yytext); return NUMBER; }
0[xX][0-9A-Fa-f]+	{ yylval.ival = strtol(yytext,NULL,16); return NUMBER; }
0[0-7]+				{ yylval.ival = strtol(yytext,NULL,8); return NUMBER; }
0[oO][0-7]+			{ yylval.ival = strtol(&yytext[2],NULL,8); return NUMBER; }
0[bB][01]+			{ yylval.ival = strtol(&yytext[2],NULL,2); return NUMBER; }
[a-zA-Z_][A-z0-9_]*				{ 
							/* is this a register? */
							yylval.ival = reg_lookup(yytext);
							if ( yylval.ival ) 		
								return(REG); 
							/* is this a symbol? */
							yylval.lval = sym_lookup(yytext); 
							if ( yylval.lval ) 
								return(SYMBOL); 
							/* aw, fuck.... */
						}
[ \t]		;
\n			return(0);
.			return(yytext[0]);

%%
int sym_lookup(char *s){
	struct symtab *sp;
	for (sp = symtable; sp < &symtable[256]; sp++ ) {
		if (sp->name && ! strcmp(sp->name, s))
			return(sp->value);
	}
}

int reg_lookup(char *s) {
	int x;
	struct symtab *sp;
	char *s1 = strdup(s);

	for (x = 0; x < strlen(s1); x++) 
		s1[x] = toupper(s1[x]);
	
	for (sp = regtable; sp < &regtable[23]; sp++ ) {
		if (! strcmp(sp->name, s1) ) {
			free(s1);
			return( sp->value);
		}
	}
	free(s1);
	return(0);
}
		

