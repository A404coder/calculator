%{
  #include <stdio.h>
  #include <stdlib.h>
  #define YYDEBUG 1
  int yylex();
  int yyerror(const char *s);
%}
%union {
  int     int_value;
  double  double_value;
}
%token <double_value>     DOUBLE_LITERAL
%token ADD SUB MUL DIV CR LP RP
%type <double_value> expression term primary_expression
%%
line_list
  : line
  | line_list line
  ;
line
  : expression CR
  {
    printf(">>%lf\n", $1);
  }
  | error CR
  {
    yyclearin;
    yyerrok;
  }
  ;
expression
  : term
  | expression ADD term
  {
    $$ = $1 + $3;
  }
  | expression SUB term
  {
    $$ = $1 - $3;
  }
  ;
term
  : primary_expression
  | term MUL primary_expression
  {
    $$ = $1 * $3;
  }
  | term DIV primary_expression
  {
    $$ = $1 / $3;
  }
  ;
primary_expression
  : DOUBLE_LITERAL
  | SUB primary_expression
  {
    $$ = -$2;
  }
  | LP expression RP
  {
    $$ = $2;
  }
  | ADD primary_expression
  {
    $$ = $2;
  }
  ;
%%
int yyerror(const char *s) {
  extern char *yytext;
  fprintf(stderr, "parser error near %s\n", yytext);
  return 0;
}

int main(void) {
  extern int yyparse(void);
  extern FILE *yyin;

  yyin = stdin;
  if(yyparse()) {
    fprintf(stderr, "Error ! Error !\n");
    exit(1);
  }
}