%{
#include <stdio.h>
#include <stdlib.h>
#include "Assignment2.tab.h"
static void comment(void);
int line_num = 0;
%}
digit [0-9]
letter [a-zA-Z]
alpha [0-9a-zA-Z]
delim [ \t]+
%%
{digit}+ { yylval = strdup(yytext);return INTEGER; }
"int main ()" {return START; }
"int"|"bool" { yylval = strdup(yytext);return TYPE; }
true|false { yylval = strdup(yytext); return BOOLEAN; }
{letter}{alpha}* { yylval = strdup(yytext); return IDENTIFIER; }
"+"|"-" { yylval = strdup(yytext);return ADDOP; }
"/"|"*"|"%" { yylval = strdup(yytext);return MULOP; }
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
"/*"	{ comment(); }				/* Marks Beginning of comment so remove it */
%%

static void comment(void)
{
	int c;
	while ((c = input()) != 0)
		if (c == '*')
		{
			while ((c = input()) == '*')
				;

			if (c == '/')
				return;

			if (c == 0)
				break;
		}
}
