%{
#include <stdlib.h>
#include "list.h"
#define YY_DECL int alpha_yylex(void* yylval)

alpha_token_t *head_list = NULL;
size_t tokens = 1;
%}

%option noyywrap
%option yylineno
%option nounistd

if if
else else
while while
for for
function function
return return
break break
continue continue
and and
not not
or or
local local
true true
false false
nil nil
equals "="
plus "+"
minus "-"
times "*"
divide "/"
mod "%"
equals_equals "=="
not_equals "!="
plus_plus "++"
minus_minus "--"
greater_than ">"
less_than "<"
greater_than_equals ">="
less_than_equals "<="
integer (0[xX][0-9a-fA-F]+)|([0-9]+)
real [0-9]*\.[0-9](e|E)?[0-9]*
string \"[^\"]*\" 
curly_bracket_open "{"
curly_bracket_close "}"
square_bracket_open "["
square_bracket_close "]"
parenthesis_open "("
parenthesis_close ")"
semicolon ";"
comma ","
colon ":"
colo_colon "::"
dot "."
dot_dot ".."
id [a-zA-Z][a-zA-Z_0-9]*
comment "//".*
multiline_comment "/\*".*"\*/"
nl \n


%%
{nl}

{if} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "IF", "<-enumerated");fprintf(yyout,"IF\n");}
{else} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "ELSE", "<-enumerated");fprintf(yyout,"ELSE\n");}
{while} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "WHILE", "<-enumerated");fprintf(yyout,"WHILE\n");}
{for} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "FOR", "<-enumerated");fprintf(yyout,"FOR\n");}
{function} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "FUNCTION", "<-enumerated");fprintf(yyout,"FUNCTION\n");}
{return} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "RETURN", "<-enumerated");fprintf(yyout,"RETURN\n");}
{break} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "BREAK", "<-enumerated");fprintf(yyout,"BREAK\n");}
{continue} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "CONTINUE", "<-enumerated");fprintf(yyout,"CONTINUE\n");}
{and} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "AND", "<-enumerated");fprintf(yyout,"AND\n");}
{not} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "NOT", "<-enumerated");fprintf(yyout,"NOT\n");}
{or} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "OR", "<-enumerated");fprintf(yyout,"OR\n");}
{local} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "LOCAL", "<-enumerated");fprintf(yyout,"LOCAL\n");}
{true} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "TRUE", "<-enumerated");fprintf(yyout,"TRUE\n");}
{false} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "FALSE", "<-enumerated");fprintf(yyout,"FALSE\n");}
{nil} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "NIL", "<-enumerated");fprintf(yyout,"NIL\n");}

{equals} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "=", "<-enumerated");fprintf(yyout,"=\n");}
{plus} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "+", "<-enumerated");fprintf(yyout,"+\n");}
{minus} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "-", "<-enumerated");fprintf(yyout,"-\n");}
{times} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "*", "<-enumerated");fprintf(yyout,"*\n");}
{divide} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "/", "<-enumerated");fprintf(yyout,"/\n");}
{mod} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "%", "<-enumerated");fprintf(yyout,"%\n");}
{equals_equals} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "==", "<-enumerated");fprintf(yyout,"==\n");}
{not_equals} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "!=", "<-enumerated");fprintf(yyout,"!=\n");}
{plus_plus} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "++", "<-enumerated");fprintf(yyout,"++\n");}
{minus_minus} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "--", "<-enumerated");fprintf(yyout,"--\n");}
{greater_than} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", ">", "<-enumerated");fprintf(yyout,">\n");}
{less_than} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "<", "<-enumerated");fprintf(yyout,"<\n");}
{greater_than_equals} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", ">=", "<-enumerated");fprintf(yyout,">=\n");}
{less_than_equals} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "<=", "<-enumerated");fprintf(yyout,"<=\n");}

{integer} {add_node(&head_list, yylineno, tokens++, yytext, "CONST INT", yytext, "<-integer");fprintf(yyout,"INTEGER: %s\n", yytext);}
{real} {add_node(&head_list, yylineno, tokens++, yytext, "CONST REAL", yytext, "<-real");fprintf(yyout,"REAL: %s\n", yytext);}

{string} {
    char *str = yytext;
    int count = 0;
    for (int i = 0; str[i]; i++)
        if (str[i] != '\"')
            str[count++] = str[i]; // if not a quote, keep it
    str[count] = '\0';
    add_node(&head_list, yylineno, tokens++, str, "STRING", "\"this_is_a_string\"", "<-char*");fprintf(yyout, "STRING: %s\n", yytext);
}

{curly_bracket_open} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "LEFT_BRACE", "<-enumerated");fprintf(yyout,"{\n");}
{curly_bracket_close} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "RIGHT_BRACE", "<-enumerated");fprintf(yyout,"}\n");}
{square_bracket_open} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "LEFT_BRACKET", "<-enumerated");fprintf(yyout,"[\n");}
{square_bracket_close} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "RIGHT_BRACKET", "<-enumerated");fprintf(yyout,"]\n");}
{parenthesis_open} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "LEFT_PARENTHESES", "<-enumerated");fprintf(yyout,"(\n");}
{parenthesis_close} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "RIGHT_PARENTHESES", "<-enumerated");fprintf(yyout,")\n");}
{semicolon} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "SEMICOLON", "<-enumerated");fprintf(yyout,";\n");}
{comma} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "COMMA", "<-enumerated");fprintf(yyout,",\n");}
{colon} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "COLON", "<-enumerated");fprintf(yyout,":\n");}
{colo_colon} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "DOUBLE_COLON", "<-enumerated");fprintf(yyout,"::\n");}
{dot} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "DOT", "<-enumerated");fprintf(yyout,".\n");}
{dot_dot} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "DOUBLE_DOT", "<-enumerated");fprintf(yyout,"..\n");}

{id} {add_node(&head_list, yylineno, tokens++, yytext, "ID", "\"this_is_an_id\"", "<-char*"); fprintf(yyout,"ID: %s\n", yytext);}
{comment} {add_node(&head_list, yylineno, tokens++, "", "COMMENT", "LINE_COMMENT", "<-enumerated");fprintf(yyout,"COMMENT: %s\n", yytext);}
{multiline_comment} {add_node(&head_list, yylineno, tokens++, "", "COMMENT", "MULTILINE_COMMENT", "<-enumerated");fprintf(yyout,"COMMENT: %s\n", yytext);}

%%

int main(int argc, char *argv[]){
    if(argc > 1){
        if(!(yyin = fopen(argv[1], "r"))){
            fprintf(stderr, "Cannot open file: %s\n", argv[1]);
            return 1;
        }
        if((yyout = fopen(argv[2], "w+"))){}
        else yyout = stderr;
    }

    alpha_yylex(head_list);
    alpha_token_t *token = head_list;
    while(token != NULL){
        fprintf(yyout,"%u:\t #%u\t \"%s\"\t %s\t %s\t %s\n", token->numline, token->numToken, token->content, token->category, token->type, token->additional_info);
        token = token->next;
    }
    return 0;
}


/*TODO: FIX MULTILINE COMMENTS*/