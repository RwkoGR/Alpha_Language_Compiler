#include <stdio.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


struct stack{
    struct stack *next;
    char* operator;
    int initial_line;
};

typedef struct stack stack_t;

void push(stack_t **stack, char* operator, int lineno);

int pop(stack_t **stack);