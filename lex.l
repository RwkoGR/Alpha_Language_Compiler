%{
#include <stdlib.h>
#include <stdio.h>
#include "list.h"
#include "stack.h"
#define YY_DECL int alpha_yylex(void* yylval)

alpha_token_t *head_list = NULL;
stack_t *top = NULL;
stack_t *top_string = NULL;
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
string "\""
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
block_comment "/*"
nl \n
space [ \t\r\f\v]+
 
undefined .

%%
{nl}
{space}

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

{integer} {add_node(&head_list, yylineno, tokens++, yytext, "CONST_INT", yytext, "<-integer");fprintf(yyout,"INTEGER: %s\n", yytext);}
{real} {add_node(&head_list, yylineno, tokens++, yytext, "CONST_REAL", yytext, "<-real");fprintf(yyout,"REAL: %s\n", yytext);}

{string} {
    int c;
    int previous_len = 1;
    char *text = malloc(previous_len);
    stack_t *stack = top_string;
    push(&stack, "\"" , 0);
    
    while ((c = input()) != 0) {
        if(c == '\"'){
            pop(&stack);
            
            add_node(&head_list, yylineno, tokens++, text, "STRING", "\"this_is_a_string\"", "<-char*");fprintf(yyout, "STRING: %s\n", yytext);
            break;
        }
        else{
            if(c == '\\'){
                switch(c = input()){
                    case 'n':
                        c = '\n';
                        break;
                    case 't':
                        c = '\t';
                        break;
                    case 'r':
                        c = '\r';
                        break;
                    case 'b':
                        c = '\\';
                        text = realloc(text, previous_len + 1);
                        text[previous_len - 1] = c;
                        text[previous_len] = '\0';
                        previous_len++;
                        c = 'b';
                        break;
                    case 'f':
                        c = '\f';
                        break;
                    case 'v':
                        c = '\v';
                        break;
                    case 'a':
                        c = '\a';
                        break;
                    case '\\':
                        c = '\\';
                        break;
                    case '\'':
                        c = '\'';
                        break;
                    case '\"':
                        c = '\"';
                        break;
                    case '?':
                        c = '\?';
                        break;
                    case '0':
                        c = '\0';
                        break;
                    default:
                        break;
                }
            }
            text = realloc(text, previous_len + 1);
            text[previous_len - 1] = c;
            text[previous_len] = '\0';
            previous_len++;
        }
    }
    if(stack != NULL){
        fprintf(yyout,"ERROR IN STRINGS! \n");
        exit(0);
    }
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
{block_comment} {
    int c;
    int initial_line = 0;
    int final_line = 0;
    char *text = malloc(6);
    stack_t *stack = top;
    push(&stack, "/*" , yylineno);
    while ((c = input()) != 0) {
        if(c == '/'){
            if ((c = input()) == '*'){
                fprintf(yyout,"open COMMENT: %d\n", yylineno);
                push(&stack, "/*", yylineno);
            }
            else{
                unput(c);
            }
        }
        else if(c == '*'){
            if ((c = input()) == '/'){
                fprintf(yyout,"CLOSING COMMENT: %d\n", yylineno);
                initial_line = pop(&stack);
                sprintf(text, "%d-%d", initial_line,yylineno);
                
                if(stack == NULL){
                    add_node(&head_list, initial_line, tokens++, text, "COMMENT", "BLOCK_COMMENT", "<-enumerated");
                    break;
                }
                else
                    add_node(&head_list, initial_line, tokens++, text, "COMMENT", "NESTED_COMMENT", "<-enumerated");
            }
            else{
                unput(c);
            }
        }
    }
    if(stack != NULL){
        fprintf(yyout,"ERROR IN COMMENTS! \n");
        exit(0);
    }
}

{undefined} {fprintf(yyout,"ERROR! Undefined character: %s in line %d.\n", yytext ,yylineno);}

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