%{
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
static void comment(void);
%}

%{
	FILE * myfd;
	int line_num=0;
	int fl = 0;
%}

digit [0-9]
letter [a-zA-Z_]
Alpha [a-zA-Z_0-9]
dot "."
fraction {digit}+"."{digit}+
equals =
OPER "+"|"-"|"*"|"/"
RELOP ==|<=|>=|<|>|!=
delim [ \t]*
OP "("
CP ")"
OB "{"
CB "}"
SC ";"
%%
{digit}+{letter}+ {++fl;}
{digit}+ { fprintf(myfd, "Integer\n%d\n",atoi(yytext));}
{fraction} {fprintf(myfd, "Float\n%s\n",yytext);}
if|for|while|else|int|float {fprintf(myfd, "Keyword\n%s\n",yytext);}
{equals} {fprintf(myfd, "Assignment\n=\n");}
{OPER} {fprintf(myfd, "Operator\n%s\n",yytext);}
{letter}{Alpha}* {fprintf(myfd, "Identifier\n%s\n",yytext);}
{RELOP} fprintf(myfd, "Comparison\n%s\n",yytext);
{OP} fprintf(myfd, "Open-paren\n(\n");
{CP} fprintf(myfd, "Close-paren\n)\n");
{OB} fprintf(myfd, "Open-bracket\n{\n");
{CB} fprintf(myfd, "Close-bracket\n}\n");
{SC} fprintf(myfd, "Semicolon\n;\n");
\n {line_num++;}
{delim} 					/* Ignore whitespaces tabs and newlines */
"//".*						/* Inline comments So Ignore */
"/*"	{comment();}				/* Marks Beginning of comment so remove it */
. 	{++fl;}					/* Discard bad Characters */
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
	FILE *fh;
	if (argc == 2)
	{
		if((fh = fopen(argv[1], "r")))
			yyin = fh;
		else{
			perror("No Such File");
			exit(1);
		}
	}
	myfd = fopen("flex_output.txt", "w");
	yylex();
	if( fl != 0 ){
		printf("Syntax Error\n");
	}
	else{
		printf("Success\n");
	}
}
