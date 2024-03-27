#include "scope_list.h"

int size_of_scope_arr;

void hide_scope(struct List** scope_arr, unsigned int scope){
    struct List* temp = scope_arr[scope];
    while(temp != NULL){
        ((SymbolTableEntry*)temp->pvValue)->isActive = 0;
        temp = temp->next;
    }
}


int add_node_scope_arr(struct List** scope_arr, SymbolTableEntry * symTableObj){
    assert(symTableObj != NULL);
    assert(symTableObj->value.varVal != NULL);
    unsigned int scope;
    if(symTableObj->type == 0 || symTableObj->type == 1 || symTableObj->type == 2) 
        scope = symTableObj->value.varVal->scope;
    else if(symTableObj->type == 3 || symTableObj->type == 4)
        scope = symTableObj->value.funcVal->scope;

    struct List* new_node = (struct List*)malloc(sizeof(struct List));
    new_node->next = NULL;
    new_node->pcKey = (char *)symTableObj->value.varVal->name;
    new_node->pvValue = symTableObj;
    if(scope > size_of_scope_arr){
        scope_arr = realloc(scope_arr, (size_of_scope_arr + SCOPE_NUM) * sizeof(struct List*));
        size_of_scope_arr += SCOPE_NUM;
        printf("ADDED SIZE BITCH\n :%d\n", size_of_scope_arr);
        scope_arr[scope] = new_node;
    }
    else{
        struct List* temp = scope_arr[scope];
        scope_arr[scope] = new_node;
        new_node->next = temp;
    }

    printf("\nAdded node with name: %s, scope: %d\n", new_node->pcKey, scope);

    return 1;
}

void print_nodes_scope_arr(struct List** scope_arr){
    for(int i = 0; i < size_of_scope_arr; i++){
        if(scope_arr[i] == NULL) break;
        printf("\n\n--------------- SCOPE : #%d ---------------\n\n", i);
        struct List* temp = scope_arr[i];
        while(temp != NULL){
            if(((SymbolTableEntry*)temp->pvValue)->type == 0 || ((SymbolTableEntry*)temp->pvValue)->type == 1 || ((SymbolTableEntry*)temp->pvValue)->type == 2) 
                printf("\"%s\" [%d] (line %d) (scope %d)\n", ((SymbolTableEntry*)temp->pvValue)->value.varVal->name, ((SymbolTableEntry*)temp->pvValue)->type, ((SymbolTableEntry*)temp->pvValue)->value.varVal->line, ((SymbolTableEntry*)temp->pvValue)->value.varVal->scope);
            else if(((SymbolTableEntry*)temp->pvValue)->type == 3 || ((SymbolTableEntry*)temp->pvValue)->type == 4)
                printf("\"%s\" [%d] (line %d) (scope %d)\n", ((SymbolTableEntry*)temp->pvValue)->value.funcVal->name, ((SymbolTableEntry*)temp->pvValue)->type, ((SymbolTableEntry*)temp->pvValue)->value.funcVal->line, ((SymbolTableEntry*)temp->pvValue)->value.funcVal->scope);
            temp = temp->next;
        }
    }
}

struct List** create_scope_arr(void){
    struct List** arr_of_lists = (struct List**)malloc(SCOPE_NUM * sizeof(struct List*));
    for(int i = 0; i < SCOPE_NUM; i++){
        arr_of_lists[i] = NULL;
    }
    size_of_scope_arr = SCOPE_NUM;
    return arr_of_lists;
}

