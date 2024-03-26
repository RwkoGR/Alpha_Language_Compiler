%{
#include "parser.h"
#include <stdlib.h>
#include <stdio.h>
#include "list.h"
#include "stack.h"
#define YY_DECL int alpha_yylex(void* yylval)

alpha_token_t *head_list = NULL;
stack_t *top = NULL;
stack_t *top_string = NULL;
size_t tokens = 1;
extern int functStartLine;
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

{if} {fprintf(yyout,"found IF.\n"); add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "IF", "<-enumerated"); return IF;}
{else} {fprintf(yyout,"found ELSE.\n"); add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "ELSE", "<-enumerated"); return ELSE;}
{while} {fprintf(yyout,"found WHILE.\n"); add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "WHILE", "<-enumerated"); return WHILE;}
{for} {fprintf(yyout,"found FOR.\n"); add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "FOR", "<-enumerated"); return FOR;}
{function} {functStartLine = yylineno; fprintf(yyout,"found FUNCTION.\n"); add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "FUNCTION", "<-enumerated"); return FUNCTION;}
{return} {fprintf(yyout,"found RETURN.\n"); add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "RETURN", "<-enumerated"); return RETURN;}
{break} {fprintf(yyout,"found BREAK.\n"); add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "BREAK", "<-enumerated"); return BREAK;}
{continue} {fprintf(yyout,"found CONTINUE.\n"); add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "CONTINUE", "<-enumerated"); return CONTINUE;}
{and} {fprintf(yyout,"found AND.\n"); add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "AND", "<-enumerated"); return AND;}
{not} {fprintf(yyout,"found NOT.\n"); add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "NOT", "<-enumerated"); return NOT;}
{or} {fprintf(yyout,"found OR.\n"); add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "OR", "<-enumerated"); return OR;}
{local} {fprintf(yyout,"found LOCAL.\n"); add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "LOCAL", "<-enumerated"); return local;}
{true} {fprintf(yyout,"found TRUE.\n"); add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "TRUE", "<-enumerated"); return TRUE;}
{false} {fprintf(yyout,"found FALSE.\n"); add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "FALSE", "<-enumerated"); return FALSE;}
{nil} {fprintf(yyout,"found NIL.\n"); add_node(&head_list, yylineno, tokens++, yytext, "KEYWORD", "NIL", "<-enumerated"); return NIL;}

{equals} {fprintf(yyout,"found =\n") ;add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "EQUALS", "<-enumerated"); return '=';}
{plus} {fprintf(yyout,"found +.\n"); add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "PLUS", "<-enumerated"); return '+';}
{minus} {fprintf(yyout,"found -.\n"); add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "MINUS", "<-enumerated"); return '-';}
{times} {fprintf(yyout,"found *.\n"); add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "TIMES", "<-enumerated"); return '*';}
{divide} {fprintf(yyout,"found /.\n"); add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "DIVIDE", "<-enumerated"); return '/';}
{mod} {fprintf(yyout,"found MOD.\n"); add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "MOD", "<-enumerated"); return '%';}
{equals_equals} {fprintf(yyout,"found ==.\n"); add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "EQUALS_EQUALS", "<-enumerated"); return EQUALS_EQUALS;}
{not_equals} {fprintf(yyout,"found !=.\n"); add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "NOT_EQUALS", "<-enumerated"); return NOT_EQUALS;}
{plus_plus} {fprintf(yyout,"found ++.\n"); add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "PLUS_PLUS", "<-enumerated"); return PLUS_PLUS;}
{minus_minus} {fprintf(yyout,"found --.\n"); add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "MINUS_MINUS", "<-enumerated"); return MINUS_MINUS;}
{greater_than} {fprintf(yyout,"found >.\n"); add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "GREATER_THAN", "<-enumerated"); return '>';}
{less_than} {fprintf(yyout,"found <.\n"); add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "LESS_THAN", "<-enumerated"); return '<';}
{greater_than_equals} {fprintf(yyout,"found >=.\n"); add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "GREATER_EQUAL_THAN", "<-enumerated"); return GREATER_EQUALS;}
{less_than_equals} {fprintf(yyout,"found <=.\n"); add_node(&head_list, yylineno, tokens++, yytext, "OPERATOR", "LESS_EQUAL_THAN", "<-enumerated"); return LESS_EQUALS;}

{integer} {fprintf(yyout,"found INT:%s\n",yytext);add_node(&head_list, yylineno, tokens++, yytext, "CONST_INT", yytext, "<-integer"); return NUMBER_INT;}
{real} {fprintf(yyout,"found REAL:%s\n",yytext); add_node(&head_list, yylineno, tokens++, yytext, "CONST_REAL", yytext, "<-real");  return NUMBER_FLOAT;}

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
    fprintf(yyout,"found STRING:%s.\n",text);
    return STRING;
}
    

{curly_bracket_open} {fprintf(yyout,"found CURLY_BRACKET_OPEN.\n");add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "LEFT_BRACE", "<-enumerated"); return '{';}
{curly_bracket_close} {fprintf(yyout,"found CURLY_BRACKET_CLOSE.\n");add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "RIGHT_BRACE", "<-enumerated"); return '}';}
{square_bracket_open} {fprintf(yyout,"found SQUERE_BRACKET_OPEN.\n");add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "LEFT_BRACKET", "<-enumerated"); return '[';}
{square_bracket_close} {fprintf(yyout,"found SQUERE_BRACKET_CLOSE.\n");add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "RIGHT_BRACKET", "<-enumerated");return ']';}
{parenthesis_open} {fprintf(yyout,"found PARENTHESIS_OPEN.\n");add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "LEFT_PARENTHESES", "<-enumerated");return '(';}
{parenthesis_close} {fprintf(yyout,"found PARENTHESIS_CLOSE.\n");add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "RIGHT_PARENTHESES", "<-enumerated");return ')';}
{semicolon} {fprintf(yyout,"found SENICOLON.\n");add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "SEMICOLON", "<-enumerated"); return ';';}
{comma} {fprintf(yyout,"found COMMA.\n");add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "COMMA", "<-enumerated"); return ',';}
{colon} {fprintf(yyout,"found COLON.\n");add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "COLON", "<-enumerated"); return ':';}
{colo_colon} {fprintf(yyout,"found COLON_COLON.\n");add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "DOUBLE_COLON", "<-enumerated"); return COLON_COLON;}
{dot} {fprintf(yyout,"found DOT.\n");add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "DOT", "<-enumerated"); return '.';}
{dot_dot} {fprintf(yyout,"found DOT_DOT.\n");add_node(&head_list, yylineno, tokens++, yytext, "PUNCTUATION", "DOUBLE_DOT", "<-enumerated"); return DOT_DOT;}

{id} {alpha_yylval.stringValue = strdup(yytext); ;fprintf(yyout,"found id:%s\n",yytext); add_node(&head_list, yylineno, tokens++, yytext, "ID", "\"this_is_an_id\"", "<-char*"); return ID;}
<<<<<<< HEAD
{comment} {fprintf(yyout,"found COMMENT.\n");add_node(&head_list, yylineno, tokens++, "", "COMMENT", "LINE_COMMENT", "<-enumerated"); }
=======
{comment} {fprintf(yyout,"found COMMENT.\n");add_node(&head_list, yylineno, tokens++, "", "COMMENT", "LINE_COMMENT", "<-enumerated"); return COMMENT;}
>>>>>>> 6be1eb365785e5daa243d4ea4e9795c06f5f14ed
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
    fprintf(yyout,"found BLOCK_COMMENT\n");
<<<<<<< HEAD
    // return BLOCK_COMMENT;
=======
    return BLOCK_COMMENT;
>>>>>>> 6be1eb365785e5daa243d4ea4e9795c06f5f14ed
}

{undefined} {fprintf(yyout,"ERROR! Undefined character: %s in line %d.\n", yytext ,yylineno); return NIL;}

%%

// int main(int argc, char *argv[]){
//     if(argc > 1){
//         if(!(yyin = fopen(argv[1], "r"))){
//             fprintf(stderr, "Cannot open file: %s\n", argv[1]);
//             return 1;
//         }
//         if((yyout = fopen(argv[2], "w+"))){}
//         else yyout = stderr;
//     }

//     alpha_yylex(head_list);
//     alpha_token_t *token = head_list;
//     while(token != NULL){
//         fprintf(yyout,"%u:\t #%u \t\"%s\" \t %s \t %s \t %s\n", token->numline, token->numToken, token->content, token->category, token->type, token->additional_info);
//         token = token->next;
//     }
//     return 0;
// }

/*TODO: FIX MULTILINE COMMENTS*/