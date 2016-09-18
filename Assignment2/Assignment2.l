%{
#include <stdio.h>
#include "Assignment2.tab.h"
static void comment(void);
#define YY_DECL extern int yylex()
int line_num = 0;
%}

digit [0-9]
letter [a-zA-Z]
alpha [0-9a-zA-Z]
delim [ \t]*
%%
{digit}+ { return INTEGER;}
"int main ()" {return START;}
"int" {return TYPE_INT;}
"bool" {return TYPE_BOOL;}
{letter}{alpha}* {return IDENTIFIER;}
"(" {return OP;}
")" {return CP;}
"{" {return OB;}
"}" {return CB;}
";" {return SemiColon;}
"=" {return EQ;}
\n {line_num++;}
{delim} 					/* Ignore whitespaces tabs and newlines */
"//".*						/* Inline comments So Ignore */
"/*"	{comment();}				/* Marks Beginning of comment so remove it */
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
