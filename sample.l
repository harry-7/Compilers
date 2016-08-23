%{
#include<stdio.h>
#include<stdlib.h>
static void comment(void);
%}

%{
	int line_num=0;
%}

digit [0-9]
ID [a-z][a-z0-9]*
dot "."
fraction {digit}+"."{digit}*
equals =
OPER "+"|"-"|"*"|"/"
RELOP ==|<=|>=|<|>|!=
delim [ \t]*
%%
{fraction} {printf("Float\n%f\n",atof(yytext));}
{digit}+ { printf("Integer\n%d\n",atoi(yytext));}
if|for|while|else|int|float {printf("Keyword\n%s\n",yytext);}
{equals} {printf("Assignment\n=\n");}
{OPER} {printf("Operator\n%s\n",yytext);}
{ID} {printf("Identifier\n%s\n",yytext);}
{RELOP} printf("Comparison\n%s\n",yytext);
\( printf("Open-paren\n(\n");
\) printf("Close-paren\n)\n");
\{ printf("Open-bracket\n{\n");
\} printf("Close-bracket\n}\n");
; printf("Semicolon\n");
\n {line_num++;}
{delim} 					/*Ignore whitespaces tabs and newlines*/
"//".*						/* Inline comments So Ignore*/
"/*"	{comment();}				/* Marks Beginning of comment so remove it */
. 						/* Discard bad Characters */
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

int main(int argc, char *argv[]){
	yylex();
}
