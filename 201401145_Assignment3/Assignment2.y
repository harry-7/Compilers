%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
	extern "C" int yylex();
	extern "C" int yyparse();
	extern "C" FILE *yyin;
	extern "C" int line_num;
	extern union NODE yylval;
	FILE *output_file;
	void yyerror(const char *s);
	class Prog* start = NULL;
%}
%start Program

/* Types for Non-Terminals */
%type<prog> Program
%type<decls> Declarations
%type<decl> Declaration
%type<var> Var
%type<stmts> Statements
%type<stmt> Statement
%type<expr> Expression
%type<location> Location
%type<literal> Literal

/* Terminals */
%token<value> IDENTIFIER TYPE INTEGER BOOLEAN
%token ADD SUB MUL DIV MOD
%token START EQ SC OP CP OB CB OSB CSB 

/* Precedence */
%left ADD SUB
%left MUL DIV MOD
%%
Program:
	START OP CP OB Declarations Statements CB {}
	;
Declarations:
	Declarations Declaration
	|
	;
Declaration:
	TYPE Var SC
	;
Var:
	ID
	| ID OSB INTEGER LSB SC
	;
Statements:
	Statements Statement
	|
	;
Statement:
	SC
	| Assignment
	;
Assignment:
	IDENTIFIER EQ Expression SC {fprintf(output_file, "Assignment operation encountered\n");}
	| IDENTIFIER OSB Expression CSB EQ Expression SC {fprintf(output_file, "Assignment operation encountered\n");}
	;
Expression:
    Location
    | Literal
    | Expression ADD Expression {fprintf(output_file,"ADDITION Expression Encountered\n");}
    | Expression SUB Expression {fprintf(output_file,"SUBTRACTION Expression Encountered\n");}
    | Expression MUL Expression {fprintf(output_file,"MULTIPLICATION Encountered\n");}
    | Expression DIV Expression {fprintf(output_file,"DIVISION Encountered\n");}
    | Expression MOD Expression {fprintf(output_file,"MOD Encountered\n");}
    | OP Expression CP
    ;
Location:
    IDENTIFIER
    | IDENTIFIER OSB Expression CSB
    ;

Literal:
	Integer
	| BOOLEAN { fprintf (output_file, "Boolean literal encountered\nValue=%s\n",$1);} 
	;
Integer:
	INTEGER { fprintf (output_file, "Integer literal encountered\nValue=%s\n",$1);}
	;
%%
int main(int argc, char **argv) {
	output_file = fopen("bison_output.txt","w");

	if(argc == 1) {
		printf("No Input File Given\n");
		exit(-1);
	}

	FILE *input = fopen(argv[1], "r");

	if (input == NULL){
		printf("Can't open the given file!\n");
		exit(-1);
	}
	yyin = input;
	
	do {
		yyparse();
	} while (!feof(yyin));
	printf("Success\n");
	if(start){
		start->traverse();
	}
}
void yyerror(const char *s) {
	printf("Syntax Error\n");
	exit(-1);
}
