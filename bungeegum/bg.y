%{
    #include <stdio.h>
    #include <stdlib.h>
    int yylex(void);
    void yyerror(char *);
    FILE *yyin, *fp;
    void codegen();
%}


%token NUM RET


%%
p: e            { codegen($1); }
 ;
e: RET NUM ';'  { $$ = $3; }
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


void codegen(int data)
{    
   fp = fopen("a.s", "w");
   fprintf(fp, ".text \n.global _start \n\n");
   fprintf(fp, "_start: \n");
   fprintf(fp, "       mov r0, #%d \n", data);
   fprintf(fp, "       mov r7, #1 \n");
   fprintf(fp, "swi 0\n"); 
   fclose(fp);
}
