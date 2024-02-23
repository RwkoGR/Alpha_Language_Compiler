#include "stack.h"


void push(stack_t **stack, char *operator, int lineno){
    stack_t *new_element = malloc(sizeof(stack_t));
    new_element->next = NULL;
    new_element->operator = malloc(sizeof(operator) + 1);
    strcpy(new_element->operator, operator);
    new_element->initial_line = lineno;
    if(*stack == NULL){
        *stack = new_element;
    }else{
        // stack_t *current = *stack;
        new_element->next = *stack;
        *stack = new_element;
    }
}

int pop(stack_t **stack){
    int lineno;
    if(*stack == NULL){
        return -1;
    }
    stack_t *current = *stack;
    lineno = current->initial_line;
    *stack = (*stack)->next;
    free(current);
    return lineno;
}

// void printthestack(stack_t *head){
//     stack_t *current = head;
//     while(current != NULL){
//         printf("%s\n", current->operator);
//         current = current->next;
//     }
// }
