%{
#include<stdio.h>
#include<stdlib.h>
static void comment(void);
%}

%{
	FILE * myfd;
	int line_num=0;
%}

digit [0-9]
letter [a-zA-Z_]
Alpha [a-zA-Z_0-9]
dot "."
fraction {digit}+"."{digit}*
equals =
OPER "+"|"-"|"*"|"/"
RELOP ==|<=|>=|<|>|!=
delim [ \t]*
%%
{fraction} {fprintf(myfd, "Float\n%f\n",atof(yytext));}
{digit}+ { fprintf(myfd, "Integer\n%d\n",atoi(yytext));}
if|for|while|else|int|float {fprintf(myfd, "Keyword\n%s\n",yytext);}
{equals} {fprintf(myfd, "Assignment\n=\n");}
{OPER} {fprintf(myfd, "Operator\n%s\n",yytext);}
{letter}{Alpha}* {fprintf(myfd, "Identifier\n%s\n",yytext);}
{RELOP} fprintf(myfd, "Comparison\n%s\n",yytext);
\( fprintf(myfd, "Open-paren\n(\n");
\) fprintf(myfd, "Close-paren\n)\n");
\{ fprintf(myfd, "Open-bracket\n{\n");
\} fprintf(myfd, "Close-bracket\n}\n");
; fprintf(myfd, "Semicolon\n;\n");
\n {line_num++;}
{delim} 					/* Ignore whitespaces tabs and newlines */
"//".*						/* Inline comments So Ignore */
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
	myfd = fopen("flex_output.txt", "w");
	yylex();
}
