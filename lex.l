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

{if} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "IF", "<-enumerated");}
{else} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "ELSE", "<-enumerated");}
{while} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "WHILE", "<-enumerated");}
{for} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "FOR", "<-enumerated");}
{function} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "FUNCTION", "<-enumerated");}
{return} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "RETURN", "<-enumerated");}
{break} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "BREAK", "<-enumerated");}
{continue} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "CONTINUE", "<-enumerated");}
{and} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "AND", "<-enumerated");}
{not} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "NOT", "<-enumerated");}
{or} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "OR", "<-enumerated");}
{local} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "LOCAL", "<-enumerated");}
{true} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "TRUE", "<-enumerated");}
{false} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "FALSE", "<-enumerated");}
{nil} {add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "NIL", "<-enumerated");}

{equals} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "EQUALS", "<-enumerated");}
{plus} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "PLUS", "<-enumerated");}
{minus} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "MINUS", "<-enumerated");}
{times} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "TIMES", "<-enumerated");}
{divide} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "DIVIDE", "<-enumerated");}
{mod} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "MOD", "<-enumerated");}
{equals_equals} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "EQUALS_EQUALS", "<-enumerated");}
{not_equals} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "NOT_EQUALS", "<-enumerated");}
{plus_plus} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "PLUS_PLUS", "<-enumerated");}
{minus_minus} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "MINUS_MINUS", "<-enumerated");}
{greater_than} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "GREATER_THAN", "<-enumerated");}
{less_than} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "LESS_THAN", "<-enumerated");}
{greater_than_equals} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "GREATER_EQUAL_THAN", "<-enumerated");}
{less_than_equals} {add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "LESS_EQUAL_THAN", "<-enumerated");}

{integer} {add_node(&head_list, yylineno, tokens++, yytext, "CONST_INT", yytext, "<-integer");}
{real} {add_node(&head_list, yylineno, tokens++, yytext, "CONST_REAL", yytext, "<-real");}

{string} {
    int c;
    int previous_len = 1;
    char *text = malloc(previous_len);
    stack_t *stack = top_string;
    push(&stack, "\"" , 0);
    
    while ((c = input()) != 0) {
        if(c == '\"'){
            pop(&stack);
            
            add_node(&head_list, yylineno, tokens++, text, "STRING", "\"this_is_a_string\"", "<-char*");
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
                        text = realloc(text, previous_len + 1);
                        text[previous_len - 1] = '\\';
                        text[previous_len] = '\0';
                        previous_len++;
                        fprintf(yyout,"Warning! invalid escape character %c \n",c);
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
        fprintf(yyout,"ERROR! Unclosed string in line %d.\n",yylineno);
        exit(0);
    }
}
    

{curly_bracket_open} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "LEFT_BRACE", "<-enumerated");}
{curly_bracket_close} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "RIGHT_BRACE", "<-enumerated");}
{square_bracket_open} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "LEFT_BRACKET", "<-enumerated");}
{square_bracket_close} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "RIGHT_BRACKET", "<-enumerated");}
{parenthesis_open} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "LEFT_PARENTHESES", "<-enumerated");}
{parenthesis_close} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "RIGHT_PARENTHESES", "<-enumerated");}
{semicolon} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "SEMICOLON", "<-enumerated");}
{comma} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "COMMA", "<-enumerated");}
{colon} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "COLON", "<-enumerated");}
{colo_colon} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "DOUBLE_COLON", "<-enumerated");}
{dot} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "DOT", "<-enumerated");}
{dot_dot} {add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "DOUBLE_DOT", "<-enumerated");}

{id} {add_node(&head_list, yylineno, tokens++, yytext, "ID", "\"this_is_an_id\"", "<-char*");}
{comment} {add_node(&head_list, yylineno, tokens++, "", "COMMENT", "LINE_COMMENT", "<-enumerated");}
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
                push(&stack, "/*", yylineno);
            }
            else{
                unput(c);
            }
        }
        else if(c == '*'){
            if ((c = input()) == '/'){
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
        fprintf(yyout,"ERROR! Unclosed comment block in line %d.\n",yylineno);
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
        fprintf(yyout,"%u:\t #%u \t\"%s\" \t %s \t %s \t %s\n", token->numline, token->numToken, token->content, token->category, token->type, token->additional_info);
        token = token->next;
    }
    return 0;
}

/*TODO: FIX MULTILINE COMMENTS*/