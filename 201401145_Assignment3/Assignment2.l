%{
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Assignment2.tab.h"
	int line_num = 0;
#define YY_DECL extern "C" int yylex()
%}
digit [0-9]
letter [a-zA-Z]
alpha [0-9a-zA-Z]
delim [ \t]+
%%
{digit}+ { yylval.value = strdup(yytext);return INTEGER; }
"int main" {return START; }
"int"|"bool" { yylval.value = strdup(yytext);return TYPE; }
true|false { yylval.value = strdup(yytext); return BOOLEAN; }
{letter}{alpha}* { yylval.value = strdup(yytext); return IDENTIFIER; }
"+" { yylval.value = strdup(yytext);return ADD; }
"-" { yylval.value = strdup(yytext);return SUB; }
"/" { yylval.value = strdup(yytext);return DIV; }
"*" { yylval.value = strdup(yytext);return MUL; }
"%" { yylval.value = strdup(yytext);return MOD; }
"(" { return OP; }
")" { return CP; }
"{" { return OB; }
"}" { return CB; }
";" { return SC; }
"=" { return EQ; }
"[" { return OSB; }
"]" { return CSB; }
\n { line_num++; }
{delim}					/* Ignore whitespaces tabs and newlines */
"//".*						/* Inline comments So Ignore */
"/*"([^*]|\*+[^*/])*\*+"/" /* Ignore Multi line comments */
%%
