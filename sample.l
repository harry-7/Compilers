%{
#include<stdio.h>
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

%%
{fraction} {printf("FRACTION\n%s\n",yytext);}
{digit}+ { printf("INTEGER\n%s\n",yytext);num_chars++; }
if|for|while|else|int|float {printf("Keyword\n%s\n",yytext);}
{equals} {printf("Assignment\n=\n");}
{OPER} {printf("Operator\n%s\n",yytext);}
{ID} {printf("Identifier\n%s\n",yytext);}
==|<=|>=|<|>|!= printf("Comparison\n%s\n",yytext);
\( printf("Open-paren\n(\n");
\) printf("Close-paren\n)\n");
\{ printf("Open-bracket\n{\n");
\} printf("Close-bracket\n}\n");
; printf("SEMICOLON\n");
\n {line_num++;}
[ \t] /**/
%%

int main(int argc, char *argv[]){
	yylex();
}
