%{
#include <stdio.h>
#include <stdlib.h>
	extern int yylex();
	extern int yyparse();
	extern FILE *yyin;
	extern int line_num;
	void yyerror(const char *s);
%}
%token IDENTIFIER TYPE_INT TYPE_BOOL INTEGER BOOLEAN 
%token START EQ SemiColon OP CP OB CB
%%

%%
int main(int argc, char **argv) {
	/*FILE *input = fopen("test_input", "r");
	if (!input) {
		yyerror("I can't open the given file!");
		return -1;
	}
	yyin = input;
	*/
	do {
		yyparse();
	} while (!feof(yyin));

}
void yyerror(const char *s) {
	fprintf(stderr,"EEK, parse error!  Message: %s\n",s);
	exit(-1);
}
