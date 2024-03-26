%{
        #include <stdio.h>
        #include "symtable.h"

        int alpha_yyerror(void* symTable_head,char *yaccProvideMessage);
        int alpha_yylex();
        int alpha_yyparse(void *yylval);
        struct SymTable *symTable_head = NULL;
        int cur_scope;
        int num_func;

        extern int yylineno;
        extern char* yytext;
        extern FILE* yyin;
        extern FILE* yyout;
%}

%union{
    char *stringValue;
    int intValue;
    float floatValue;
    struct SymbolTableEntry *symTableEntry;
}
%name-prefix="alpha_yy"
%parse-param {void *symTable_head}

%token COMMENT BLOCK_COMMENT
%token <stringValue> ID STRING FUNCTION
%token <intValue> NUMBER_INT
%token <floatValue> NUMBER_FLOAT
%token <stringValue> IF ELSE WHILE FOR RETURN BREAK CONTINUE
%token <stringValue> local COLON_COLON
%token <stringValue> NIL TRUE FALSE
%token <stringValue> '+' '-' '*' '/' '%'
%token <stringValue> '>' '<' GREATER_EQUALS LESS_EQUALS EQUALS_EQUALS NOT_EQUALS
%token <stringValue> AND OR
%token <stringValue> NOT PLUS_PLUS MINUS_MINUS U_MINUS
%token <stringValue> '(' ')' '[' ']'
%token <stringValue> '.' DOT_DOT
%type <symTableEntry>  STMT STMTlist EXPR assignEXPR lvalue member const primary objectdef term indexed indexedelem call elist RETURNSTMT FUNCDEF
%type <symTableEntry> FUNC_INIT FUNC_ARG_LIST BEGIN_FUNC END_FUNC IDlist IDtail

%right '='
%left OR
%left AND
%nonassoc EQUALS_EQUALS NOT_EQUALS
%nonassoc '>' GREATER_EQUALS '<' LESS_EQUALS
%left '+' '-'
%left '*' '/' '%'
%right NOT PLUS_PLUS MINUS_MINUS U_MINUS
%left '.' DOT_DOT
%left '[' ']'
%left '(' ')'

%%

program: STMTlist {printf("(Y) STMTlist\n");}

STMTlist: STMTlist STMT {printf("(Y) STMTlist STMT\n");}
        | /* empty */ {printf("(Y) EMPTY\n");}
        ;

STMT: EXPR ';' {printf("(Y) EXPR;\n");}
    | IFSTMT {printf("(Y) IFSTMT\n");}
    | WHILESTMT {printf("(Y) WHILESTMT\n");}
    | FORSTMT {printf("(Y) FORSTMT\n");}
    | RETURNSTMT {printf("(Y) RETURNSTMT\n");}
    | BREAK ';' {printf("(Y) BREAK;\n");}
    | CONTINUE ';' {printf("(Y) CONTINUE;n");}
    | BLOCK {printf("(Y) BLOCK\n");}
    | FUNCDEF {printf("(Y) FUNCDEF\n");}
    | ';' {printf("(Y) ;\n");}
    ;

EXPR:   assignEXPR {printf("(Y) assignEXPR\n");}
        | term{printf("(Y) term\n");}
        | EXPR '+' EXPR  {printf("(Y) +\n");}
        | EXPR '-' EXPR {printf("(Y) -\n");}
        | EXPR '*' EXPR {printf("(Y) *\n");}
        | EXPR '/' EXPR  {printf("(Y) /\n");}
        | EXPR '%' EXPR   {printf("(Y) MOD\n");}
        | EXPR '>' EXPR {printf("(Y) >\n");}
        | EXPR GREATER_EQUALS EXPR  {printf("(Y) GREATER_EQUALS\n");}
        | EXPR '<' EXPR  {printf("(Y) <\n");}
        | EXPR LESS_EQUALS EXPR  {printf("(Y) LESS_EQUALS\n");}
        | EXPR EQUALS_EQUALS EXPR  {printf("(Y) EQUALS_EQUALS\n");}
        | EXPR NOT_EQUALS EXPR  {printf("(Y) NOT_EQUALS\n");}
        | EXPR AND EXPR  {printf("(Y) \n");}
        | EXPR OR EXPR {printf("(Y) OR\n");}
        ;


term:   '(' EXPR ')' {printf("(Y) (EXPR)\n");}
        | U_MINUS EXPR {printf("(Y) U_MINUS EXPR\n");} //FIXME
        | NOT EXPR {printf("(Y) NOT EXPR\n");}
        | PLUS_PLUS lvalue {printf("(Y) PLUS_PLUS lvalue\n");} 
        | lvalue PLUS_PLUS {printf("(Y) lvalue PLUS_PLUS\n");} 
        | MINUS_MINUS lvalue {printf("(Y) MINUS_MINUS lvalue\n");}
        | lvalue MINUS_MINUS {printf("(Y) lvalue MINUS_MINUS\n");}
        | primary {printf("(Y) primary\n");}
        ;

assignEXPR: lvalue '=' EXPR {printf("(Y) lvalue = EXPR\n");}

primary: lvalue {printf("(Y) lvalue\n");}
        | call {printf("(Y) call\n");}
        | objectdef {printf("(Y) objectdef\n");}
        | '(' FUNCDEF ')' {printf("(Y) ( FUNCDEF ) \n");}
        | const {printf("(Y) const\n");}
        ;

lvalue: ID {
                printf("(Y) ID\n");
                $$ = SymTable_put(symTable_head, $1 ,"var");
        }
      | local ID {
                printf("(Y) local ID\n");
                $$ = SymTable_put(symTable_head, $2 ,"var");
        }
      | COLON_COLON ID {printf("(Y) COLON_COLON ID\n");}
      | member {printf("(Y) member\n");}
      ;

member: lvalue '.' ID {printf("(Y) lvalue . ID \n");}
       | lvalue '[' EXPR ']' {printf("(Y) lvalue [ EXPR ] \n");}
       | call '.' ID {printf("(Y) call . ID \n");}
       | call '[' EXPR ']' {printf("(Y) call [ EXPR ] \n");}
       ;

call:   call '(' elist ')' {printf("(Y) call ( elist )\n");}
        | call '(' EMPTY ')' {printf("(Y) call ( )\n");}
        | lvalue callsuffix {printf("(Y) lvalue callsuffix \n");}
        | '(' FUNCDEF ')' '(' elist ')' {printf("(Y) ( FUNCDEF ) ( elist )\n");}
        | '(' FUNCDEF ')' '(' EMPTY ')' {printf("(Y) ( FUNCDEF ) (  )\n");}
        ;

EMPTY : /* empty */ {printf("(Y) EMPTY\n");}

callsuffix: normcall  {printf("(Y) normcall\n");}
        | methodcall {printf("(Y) methodcall\n");}

normcall: '(' elist ')' {printf("(Y) ( elist )\n");}
        |'(' ')' {printf("(Y) ( )\n");}

methodcall: DOT_DOT ID '(' elist ')' {printf("(Y) DOT_DOT ID ( elist ) \n");}    /* Equivalent to lvalue.ID(lvalue, elist) */
        | DOT_DOT ID '(' ')' {printf("(Y) DOT_DOT ID ( ) \n");}    /* Equivalent to lvalue.ID(lvalue, elist) */

elist: EXPR {printf("(Y) EXPR\n");}
      | elist ',' EXPR {printf("(Y) elist , EXPR\n");}
      ;

objectdef: '[' elist ']' {printf("(Y) [elist] \n");}
        | '[' ']' {printf("(Y) [] \n");}
        | '[' indexed ']' {printf("(Y) [indexed] \n");}

indexed: indexedelem {printf("(Y) indexedelem\n");}
        | indexed ',' indexedelem {printf("(Y) indexed , indexedelem \n");}
        ;

indexedelem: '{' EXPR ':' EXPR '}' {printf("(Y) { EXPR : EXPR }\n");}


BLOCK:  '{'{cur_scope++;} STMTlist {cur_scope--;}'}' {printf("(Y) { STMTlist }\n");}

        
BEGIN_FUNC: {


}

END_FUNC:{

}

FUNC_INIT: FUNCTION {
                printf("(Y) FUNCTION \n");

                char *str;
                char str_num[50];
                sprintf(str_num, "%d", num_func);
                str = malloc(strlen("$") + strlen(str_num) + 1);
                if(!str) return -1;
                strcat(str, "$");
                strcat(str, str_num);
                str[strlen(str)] = '\0';
                num_func++;
                $$ = SymTable_put(symTable_head, str,"func");
        }
        | FUNCTION ID {
                printf("(Y) FUNCTION ID ");
                $$ = SymTable_put(symTable_head, $2 ,"func");
        }

FUNC_ARG_LIST: '(' IDlist ')' {
                printf("(Y) ( IDlist )");
        }
        | '(' ID ')'{
                cur_scope++;
                $$ = SymTable_put(symTable_head, $2 ,"func var");
                printf("(Y) ( ID )\n");
                cur_scope--;
        }
                
        | '(' ')' {printf("(Y) ( )");}

FUNCDEF: FUNC_INIT FUNC_ARG_LIST BEGIN_FUNC BLOCK END_FUNC {printf("(Y) COMPLETE FUNC\n");}


const: NUMBER_INT  {printf("(Y) NUMBER_INT\n");}
        | NUMBER_FLOAT  {printf("(Y) NUMBER_FLOAT\n");}
        | STRING  {printf("(Y) STRING\n");}
        | NIL  {printf("(Y) NIL\n");}
        | TRUE  {printf("(Y) TRUE\n");}
        | FALSE {printf("(Y) FALSE\n");}

IDlist: ID IDtail{
                cur_scope++;
                $$ = SymTable_put(symTable_head, $1 ,"func var");
                printf("(Y) ID\n");
                cur_scope--;
        }

IDtail:   ',' ID IDtail {
                cur_scope++;
                $$ = SymTable_put(symTable_head, $2 ,"func var");
                printf("(Y) , ID IDtail\n");
                cur_scope--;
        }
        | ',' ID {
                cur_scope++;
                $$ = SymTable_put(symTable_head, $2 ,"func var");
                printf("(Y) , ID IDtail\n");
                cur_scope--;
        }

IFSTMT: IF '(' EXPR ')' STMT ELSE STMT  {printf("(Y) IF ( EXPR ) STMT ELSE STMT\n");}
        | IF '(' EXPR ')' STMT {printf("(Y) IF ( EXPR ) STMT\n");}
        ;
 
WHILESTMT: WHILE '(' EXPR ')' STMT {printf("(Y) WHILE ( EXPR ) STMT\n");}

FORSTMT: FOR '(' elist ';' EXPR ';' elist ')' STMT {printf("(Y) FOR ( elist ; EXPR ; elist ) STMT\n");}
        | FOR '(' ';' EXPR ';' elist ')' STMT {printf("(Y) FOR (  ; EXPR ; elist ) STMT\n");}
        | FOR '(' elist ';' EXPR ';' ')' STMT {printf("(Y) FOR ( elist ; EXPR ;  ) STMT\n");}
        | FOR '('  ';' EXPR ';' ')' STMT {printf("(Y) FOR (  ; EXPR ;  ) STMT\n");}

RETURNSTMT: RETURN EXPR ';' {printf("(Y) RETURN EXPR ;\n");}
        | RETURN ';'    {printf("(Y) RETURN;\n");}
        ;


%%

int alpha_yyerror(void* symTable_head,char *yaccProvideMessage){
    fprintf(stderr,"%s: at line %d, before token: %s\n", yaccProvideMessage, yylineno, yytext);
    fprintf(stderr,"INPUT NOT VALID\n");
}

int main(int argc, char **argv) {
    if(argc > 1){
        if(!(yyin = fopen(argv[1], "r"))){
            fprintf(stderr, "Cannot open file: %s\n", argv[1]);
            return 1;
        }
        if((yyout = fopen(argv[2], "w+"))){}
        else yyout = stderr;
    }
    num_func = 0;
    cur_scope = 0;
    symTable_head = SymTable_new();
    alpha_yyparse(symTable_head);
    SymTable_print(symTable_head);
    return 0;
}
