%{
    #include <stdio.h>

    int yylex(void);
    void yyerror(const char *s);
    extern int yylineno;
    
%}

%define parse.error verbose

%token INT FLOAT DOUBLE IF ELSE WHILE RETURN
%token ID_FUNC ID_GLOBAL ID_LOCAL NUM
%token EQ NE LE LT GE GT AND OR INVALID

%left '+' '-'
%left '*' '/'
%left '^' '%'
%right UMINUS

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

programa
    : lista_elementos
    ;

lista_elementos
    : elemento_topo
    | lista_elementos elemento_topo
    ;

elemento_topo
    : declaracao_global
    | funcao
    ;

declaracao_global
    : tipo ID_GLOBAL ';'
    ;

tipo
    : INT
    | FLOAT
    | DOUBLE
    ;

funcao
    : tipo ID_FUNC '(' parametros_opcionais ')' bloco
    ;

parametros_opcionais
    : /*vazio*/
    | lista_parametros
    ;

lista_parametros
    : parametro
    | lista_parametros ',' parametro
    ;

parametro
    : tipo ID_LOCAL
    ;

bloco
    : '{' lista_comandos '}'
    ;

lista_comandos
    : /*vazio*/
    | lista_comandos comando
    ;

comando
    : declaracao_local
    | atribuicao ';'
    | chamada_funcao ';'
    | retorno ';'
    | condicional
    | repeticao
    | bloco
    ;

declaracao_local
    : tipo ID_LOCAL ';'
    ;

atribuicao
    : ID_LOCAL '=' expressao
    | ID_GLOBAL '=' expressao
    ;

chamada_funcao
    : ID_FUNC '(' argumentos_opcionais ')'
    ;

argumentos_opcionais
    : /*vazio*/
    | lista_argumentos
    ;

lista_argumentos
    : expressao
    | lista_argumentos ',' expressao
    ;

retorno
    : RETURN expressao
    ;

condicional
    : IF '(' condicao ')' comando %prec LOWER_THAN_ELSE
    | IF '(' condicao ')' comando ELSE comando
    ;

repeticao
    : WHILE '(' condicao ')' comando
    ;

condicao
    : comparacao operador_logico comparacao
    | comparacao
    ;

comparacao
    : expressao operador_relacional expressao
    ;

operador_logico
    : AND
    | OR
    ;

operador_relacional
    : EQ
    | NE
    | GE
    | GT
    | LE
    | LT
    ;

expressao
    : NUM
    | ID_LOCAL
    | ID_GLOBAL
    | chamada_funcao
    | '(' expressao ')'
    | expressao '+' expressao
    | expressao '-' expressao
    | expressao '*' expressao
    | expressao '/' expressao
    | expressao '^' expressao
    | expressao '%' expressao
    | '-' expressao %prec UMINUS
    ;

%%

void yyerror(const char *s){
    fprintf(stderr, "Erro sintatico na linha %d: %s \n", yylineno, s);
}

int main(void){
    int resultado =  yyparse();

    if (resultado == 0){
        printf("Analise lexica concluida.\n");
        printf("Analise sintatica concluida.\n");
        printf("Programa reconhecido com sucesso.\n");
        return 0;
    }

    return 1;
}
