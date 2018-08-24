%{
    #include <stdio.h>
    #include <stdlib.h>
    int yylex(void);
    void yyerror(char *);
    FILE *yyin, *fp;
    int  node(char *token, int l, int r);
%}


%token NUM RET


%%
e: e '+' e ';' {$$ = node("+", $1, $3); }
  |  e '-' e ';'  { $$ = node("-", $1, $3); }
  | NUM
  ;
%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    exit(1);
}




int main(int argc, char *argv[])
{
    int a;
    yyin = fopen(argv[1], "r");
    a = yyparse();
    if (!a) {
      printf("compiled \n");
    } else {
      printf(".parse error \n");
    }
    fclose(yyin);
   
    return 0;
}


int node(char *token, int l, int r)
{
   switch (*token)
   {
   case '+':
     token = "add";
     break;
   case '-':
     token = "sub";
     break;
   }
   
   fp = fopen("a.s", "w");
   fprintf(fp, ".text \n.global _start \n\n");
   fprintf(fp, "_start: \n");
   fprintf(fp, "       mov r1, #%d \n", l);
   fprintf(fp, "       mov r2, #%d \n", r);
   fprintf(fp, "       %s r0, r1, r2 \n", token);
   fprintf(fp, "       mov r7, #1 \n");
   fprintf(fp, "swi 0\n"); 
   fclose(fp);
}
