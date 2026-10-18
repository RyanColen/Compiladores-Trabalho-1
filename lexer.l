%{
    #include "parser.tab.h"
    #include <stdio.h>
%}

%option noyywrap yylineno

NUMERO          [0-9]+
NOME_FUNCAO     [a-z]+[A-Z][a-zA-A0-9]*
LOCAL           [a-z][a-z0-9]*
GLOBAL          [A-Z][A-Z0-9]*
NOME_GERAL      [a-zA-Z][a-zA-Z0-9]*

%%

[ \n\t\r]+      ;

"int"           {return INT;}
"float"         {return FLOAT;}
"double"        {return DOUBLE;}
"if"            {return IF;}
"else"          {return ELSE;}
"while"         {return WHILE;}
"return"        {return RETURN;}

"principal"     {return ID_FUNC;}
"main"          {return ID_FUNC;}

{NOME_FUNCAO}   {return ID_FUNC;}
{GLOBAL}        {return ID_GLOBAL;}
{LOCAL}         {return ID_LOCAL;}
{NUMERO}        {return NUM;}

"=="            {return EQ;}
"!="            {return NE;}
">="            {return GE;}
"<="            {return LE;}
">"             {return GT;}
"<"             {return LT;}
"&&"            {return AND;}
"||"            {return OR;}

"="             {return '=';}
"+"             {return '+';}
"-"             {return '-';}
"*"             {return '*';}
"/"             {return '/';}
"^"             {return '^';}
"%"             {return '%';}

"("             {return '(';}
")"             {return ')';}
"{"             {return '{';}
"}"             {return '}';}
"["             {return '[';}
"]"             {return ']';}

";"             {return ';';}
","             {return ',';}

{NOME_GERAL} {
    fprintf(stderr, "Erro lexico na linha %d: identificador fora do padrao: %s \n", yylineno, yytext);
    return INVALID;
}

. {
    fprintf(stderr, "Erro lexico na linha %d: caractere inesperado: %s \n", yylineno, yytext);
    return INVALID;
}

%%
