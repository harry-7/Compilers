%{
#include <bits/stdc++.h>
#include "ClassDefs.h"

	extern "C" int yylex();
	extern "C" int yyparse();
	extern "C" FILE *yyin;
	extern "C" int line_num;
	extern union Node yylval;
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
%token<value> ID TYPE BOOLEAN
%token<number> INTEGER
%token<value> ADD SUB MUL DIV MOD
%token START EQ SC OP CP OB CB OSB CSB 

/* Precedence */
%left ADD SUB
%left MUL DIV MOD
%%
Program:
	START OP CP OB Declarations Statements CB {
		$$ = new Prog($5,$6);
		start = $$;
	}
	;
Declarations:
	/* Empty . This is the base case so initialise here*/
	{
		$$ = new Decls();
	}
	| Declarations Declaration {$$->push_back($2);}
	;
Declaration:
	TYPE Var SC{
		$$ = new Decl(string($1),$2);
	}
	;
Var:
	ID {$$ = new Var(string("Normal"),string($1));}
	| ID OSB INTEGER CSB SC {$$ = new Var(string("Array"),string($1),$3);}
	;
Statements:
	/* Empty */ { $$ = new Stmts(); }
	| Statements Statement {$$->push_back($2);} 
	;
Statement:
	Location EQ Expression SC { $$ = new Assignment($1,$3);}
	;
Expression:
    Location {$$ = $1;}
    | Literal {$$ = $1;}
    | Expression ADD Expression {$$ = new BinExpr($1,string($2),$3);}
    | Expression SUB Expression {$$ = new BinExpr($1,string($2),$3);}
    | Expression MUL Expression {$$ = new BinExpr($1,string($2),$3);}
    | Expression DIV Expression {$$ = new BinExpr($1,string($2),$3);}
    | Expression MOD Expression {$$ = new BinExpr($1,string($2),$3);}
    | OP Expression CP {$$ = new EnclExpr($2);}
    ;
Location:
    ID {$$ = new Location(string($1),string("Normal"));}
    | ID OSB Expression CSB {$$ = new Location(string($1),string("Array"),$3);}
    ;

Literal:
	INTEGER { $$ = new intLiteral($1);}
	| BOOLEAN { $$ = new boolLiteral(string($1));} 
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
