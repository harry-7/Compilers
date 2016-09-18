%{
#include <stdio.h>
#include <stdlib.h>
	extern int yylex();
	extern int yyparse();
	extern FILE *yyin;
	FILE *output_file;
	extern int line_num;
	void yyerror(const char *s);
%}
%token IDENTIFIER TYPE INTEGER BOOLEAN 
%token START EQ SC OP CP OB CB OSB CSB ADDOP MULOP
%%
Program:
	START OB Declarations Statements CB { fprintf(output_file, "Program Encountered\n");}
	;
Declarations:
	Declarations Declaration|
	Declaration
	;
Declaration:
	TYPE IDENTIFIER SC {
	if (strcmp($1,"int") == 0) fprintf(output_file, "int");
	else if (strcmp($1,"bool") == 0) fprintf(output_file, "bool");
	fprintf(output_file, " declaration encountered\nId=%s\n",$2);
	}
	| TYPE IDENTIFIER OSB INTEGER CSB SC {
	if (strcmp($1,"int") == 0) fprintf(output_file, "int");
	else if (strcmp($1,"bool") == 0) fprintf(output_file, "bool");
	fprintf(output_file, "Boolean declaration encountered\nId=%s\nSize=%s\n",$2,$4);
	}
	;
Statements:
	Statements Statement
	| Statement
	;
Statement:
	SC
	| Assignment
	;
Assignment:
	IDENTIFIER EQ Expression SC {fprintf(output_file, "Assignment operation encountered\n");}
	| IDENTIFIER OSB INTEGER CSB EQ Expression SC {fprintf(output_file, "Assignment operation encountered\n");}
	;
Expression:
	Term ADDOP Term { 
		if(strcmp($2,"+") == 0) fprintf(output_file, "Addition expression encountered\n");
		else fprintf(output_file, "Subtraction expression encountered\n");
	}
	| Term
	;
Term:
	Factor MULOP Factor {
		if (strcmp($2,"/") == 0) fprintf(output_file, "Division expression encountered\n");
		else if (strcmp($2,"*") == 0) fprintf(output_file, "Multiplication expression encountered\n");
		else if (strcmp($2,"%") == 0) fprintf(output_file, "Modulus expression encountered\n");
	}
	| Factor
Factor:
	IDENTIFIER
	| OSB IDENTIFIER CSB
	| Literal
	| OP Expression CP
	;
Literal:
	INTEGER { fprintf (output_file, "Integer literal encountered\nValue=%s\n",$1);}
	| BOOLEAN { fprintf (output_file, "Boolean literal encountered\nValue=%s\n",$1);} 
	;
%%
int main(int argc, char **argv) {
	output_file = fopen("bison_output.txt","w");
	FILE *input = fopen("test_input", "r");
	if (!input) {
		yyerror("I can't open the given file!");
		return -1;
	}
	yyin = input;
	
	do {
		yyparse();
	} while (!feof(yyin));
	printf("Success\n");
}
void yyerror(const char *s) {
	printf("Syntax Error\n");
	exit(-1);
}
