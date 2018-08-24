%{
    #include "y.tab.h"
    #include <stdlib.h>
    void yyerror(char *);
%}

%%

[0-9]+      { yylval = atoi(yytext); return NUM;  }

"ret"       { return RET; }

[-+;]         return *yytext;


[ \t]+       /* ignore whitespaces */

.           { yyerror("syntax error"); }

%%

int yywrap(void) {
    return 1;
}
