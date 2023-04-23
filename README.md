## 计算器
利用lex、yacc实现

%{
  #include <stdio.h>
  #include <stdlib.h>
  #define YYDEBUG 1
  int yylex();
  int yyerror(const char *s);
%}
