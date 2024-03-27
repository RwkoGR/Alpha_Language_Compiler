#include "symtable.h"
#include "scope_list.h"

extern int cur_scope;
extern int yylineno;
extern int num_func;
extern struct List **scope_arr;
int functStartLine;
char **lib_funcs; //12


/* Return a hash code for pcKey. */
static unsigned int SymTable_hash(const char *pcKey){
    size_t ui;
    unsigned int uiHash = 0U;
    for (ui = 0U; pcKey[ui] != '\0'; ui++)
        uiHash = uiHash * HASH_MULTIPLIER + pcKey[ui];
    return uiHash%BUCKETS;
}


SymTable_T SymTable_new(void){
    SymTable_T hash_t = (SymTable_T)malloc(sizeof(struct SymTable));
    hash_t->buckets = BUCKETS;
    hash_t->count = 0;
    hash_t->nodes = calloc(hash_t->buckets,sizeof(struct List*));
    for(int i = 0 ; i < BUCKETS ; i++){
        hash_t->nodes[i] = NULL;
    }
    num_func = 0;
    lib_funcs = malloc(LIBFUNCNUM * sizeof(char *));
    lib_funcs[0] = malloc(strlen("print")+1);
    strcpy(lib_funcs[0], "print");
    lib_funcs[1] = malloc(strlen("input")+1);
    strcpy(lib_funcs[1], "input");
    lib_funcs[2] = malloc(strlen("objectmemberkeys")+1);
    strcpy(lib_funcs[2], "objectmemberkeys");
    lib_funcs[3] = malloc(strlen("objecttotalmembers")+1);
    strcpy(lib_funcs[3], "objecttotalmembers");
    lib_funcs[4] = malloc(strlen("objectcopy")+1);
    strcpy(lib_funcs[4], "objectcopy");
    lib_funcs[5] = malloc(strlen("totalarguments")+1);
    strcpy(lib_funcs[5],"totalarguments");
    lib_funcs[6] = malloc(strlen("argument")+1);
    strcpy(lib_funcs[6],"argument");
    lib_funcs[7] = malloc(strlen("typeof")+1);
    strcpy(lib_funcs[7],"typeof");
    lib_funcs[8] = malloc(strlen("strtonum")+1);
    strcpy(lib_funcs[8],"strtonum");
    lib_funcs[9] = malloc(strlen("sqrt")+1);
    strcpy(lib_funcs[9],"sqrt");
    lib_funcs[10] = malloc(strlen("cos")+1);
    strcpy(lib_funcs[10],"cos");
    lib_funcs[11] = malloc(strlen("sin")+1);
    strcpy(lib_funcs[11],"sin");
    SymTable_put(hash_t,lib_funcs[0],"lib_func");
    SymTable_put(hash_t,lib_funcs[1],"lib_func");
    SymTable_put(hash_t,lib_funcs[2],"lib_func");
    SymTable_put(hash_t,lib_funcs[3],"lib_func");
    SymTable_put(hash_t,lib_funcs[4],"lib_func");
    SymTable_put(hash_t,lib_funcs[5],"lib_func");
    SymTable_put(hash_t,lib_funcs[6],"lib_func");
    SymTable_put(hash_t,lib_funcs[7],"lib_func");
    SymTable_put(hash_t,lib_funcs[8],"lib_func");
    SymTable_put(hash_t,lib_funcs[9],"lib_func");
    SymTable_put(hash_t,lib_funcs[10],"lib_func");
    SymTable_put(hash_t,lib_funcs[11],"lib_func");

    return hash_t;
}

void SymTable_free(SymTable_T oSymTable){
    SymTable_T hash_t = oSymTable;
    struct List *bucket_head;
    struct List *traversal_ptr;
    struct List *traversal_ptr_prev;
    int i;

    if(!(oSymTable)){
        return;
    }
    for(i = 0 ; i < BUCKETS ; i++){
        /*Find bucket's head of the list*/
        bucket_head = hash_t->nodes[i];
        traversal_ptr = bucket_head;
        traversal_ptr_prev = traversal_ptr;
        while(traversal_ptr){
            traversal_ptr_prev = traversal_ptr;
            traversal_ptr = traversal_ptr->next;
            free(traversal_ptr_prev);
        }
    }
    free(oSymTable);
}

unsigned int SymTable_getLength(SymTable_T oSymTable){
    SymTable_T hash_t = oSymTable;
    assert(oSymTable != NULL);
    return hash_t->count;
}


SymbolTableEntry* SymTable_put(SymTable_T oSymTable, const char *pcKey, char *type){
    SymTable_T hash_t = oSymTable;
    struct List *bucket_head;
    struct List *new_node = malloc(sizeof(struct List));
    unsigned int node_hash;
    int i = 0, flag = 0;
    assert(oSymTable != NULL && pcKey != NULL  && new_node);
    
    /*Check if key already exists*/
    if(strcmp(type, "lib_func")){
        if(SymTable_contains(oSymTable,pcKey,type) == 1) return 0;
    }
    printf("NNN n shit");
    /*Find key's bucket*/
    node_hash = SymTable_hash(pcKey);
    /*Find bucket's head of the list*/
    bucket_head = hash_t->nodes[node_hash];

    /*Initialize new node*/
    new_node->pcKey = strcpy(malloc(strlen(pcKey) + 1),pcKey);
    SymbolTableEntry* symTableObj = malloc(sizeof(SymbolTableEntry));
    symTableObj->isActive = 1;
    if(strcmp(type,"var") == 0 || strcmp(type,"local_var") == 0){
        Variable *obj = (Variable *) malloc(sizeof(Variable));
        obj->name = pcKey;
        obj->scope = cur_scope;
        obj->line = yylineno;
        symTableObj->value.varVal = obj;
        if(cur_scope == 0) symTableObj->type = GLOBAL;
        else symTableObj->type = LOCAL;
        assert(symTableObj->value.varVal != NULL);
    }
    else if(strcmp(type,"func") == 0 || !strcmp(type,"lib_func")){
        Function *obj1 = (Function *) malloc(sizeof(Function));
        obj1->name = pcKey;
        while(i < LIBFUNCNUM){
            if(!strcmp(pcKey, lib_funcs[i])){
                flag = 1;
            }
            i++;
        }
        if(flag){
            symTableObj->type = LIBFUNC;
            obj1->scope = 0;
            obj1->line = 0;
        }
        else {
            symTableObj->type = USERFUNC;
            obj1->scope = cur_scope;
            obj1->line = functStartLine;
        }
        symTableObj->value.funcVal = obj1;
        assert(symTableObj->value.funcVal != NULL);
    }
    else if(!strcmp(type, "formal")){
        Variable *obj = (Variable *) malloc(sizeof(Variable));
        obj->name = pcKey;
        obj->scope = cur_scope;
        obj->line = yylineno;
        symTableObj->value.varVal = obj;
        symTableObj->type = FORMAL;
        assert(symTableObj->value.varVal != NULL);
    }
    if(!add_node_scope_arr(scope_arr, symTableObj)) printf("\n\t (!) Error: Can not add node to scope array.\n");
    new_node->pvValue = (void *)symTableObj;
    
    /*Check if bucket(list) has been initialized and if not, initilize it with new node as head*/
    if(!bucket_head){
        new_node->next = NULL;
    }
    /*If it is initialized ,insert the new node to the list as head */
    /*insert it at the end of the list */
    else{
        new_node->next = bucket_head;
    }
    hash_t->count++;
    bucket_head = new_node;
    hash_t->nodes[node_hash] = bucket_head;
    return symTableObj;    
}

void SymTable_print(SymTable_T oSymTable){
    SymTable_T hash_t = oSymTable;
    struct List *bucket_head;
    struct List *traversal_ptr;
    int i;
    assert(oSymTable != NULL);
    printf("key_hash = %u\n",SymTable_hash("x"));
    bucket_head = hash_t->nodes[SymTable_hash("x")];
    traversal_ptr = bucket_head;
    
    for(i = 0 ; i < BUCKETS ; i++){
        /*Find bucket's head of the list*/
        bucket_head = hash_t->nodes[i];
        traversal_ptr = bucket_head;
        while(traversal_ptr){
            printf("Key: %s\n",traversal_ptr->pcKey);
            printf("\tisActive:%d\n\tType:%d\n",((SymbolTableEntry *)traversal_ptr->pvValue)->isActive,
                    ((SymbolTableEntry *)traversal_ptr->pvValue)->type);
            if(((SymbolTableEntry *)traversal_ptr->pvValue)->type == 0 || ((SymbolTableEntry *)traversal_ptr->pvValue)->type == 1 || ((SymbolTableEntry *)traversal_ptr->pvValue)->type == 2){
                printf("\tScope:%d\n\tLine:%d\n",(
                        (SymbolTableEntry *)traversal_ptr->pvValue)->value.varVal->scope ,
                        ((SymbolTableEntry *)traversal_ptr->pvValue)->value.varVal->line);
            }
            else if(((SymbolTableEntry *)traversal_ptr->pvValue)->type == 3 || ((SymbolTableEntry *)traversal_ptr->pvValue)->type == 4){
                printf("\tScope:%d\n\tLine:%d\n",(
                        (SymbolTableEntry *)traversal_ptr->pvValue)->value.funcVal->scope ,
                        ((SymbolTableEntry *)traversal_ptr->pvValue)->value.funcVal->line);
            }
            traversal_ptr = traversal_ptr->next;
        }
    }

}


int SymTable_remove(SymTable_T oSymTable, const char *pcKey){
    SymTable_T hash_t = oSymTable;
    struct List *bucket_head;
    struct List *traversal_ptr;
    struct List *traversal_ptr_prev;
    unsigned int node_hash;
    assert(oSymTable != NULL && pcKey != NULL);

    /*Find key's bucket*/
    node_hash = SymTable_hash(pcKey);
    /*Find bucket's head of the list*/
    bucket_head = hash_t->nodes[node_hash];

    /*if head is null it means the key doesnt exist*/
    if(!bucket_head) return 0;
    
    /*else we find the position*/
    traversal_ptr = bucket_head;
    while(traversal_ptr && strcmp(traversal_ptr->pcKey,pcKey) != 0){
        traversal_ptr_prev = traversal_ptr;
        traversal_ptr = traversal_ptr->next;
    }

    /*again if traversal_ptr is null it means the key doesnt exist*/
    if(!traversal_ptr) return 0;
    
    /*if the node is the head of the list, make next node the head and delete the node with the key*/
    if(traversal_ptr == bucket_head){
        hash_t->nodes[node_hash] = traversal_ptr->next;
    }
    else{
        traversal_ptr_prev->next = traversal_ptr->next;
    }
    traversal_ptr = NULL;
    free(traversal_ptr);
    hash_t->count--;

    return 1;
}

//0 vale
//1 mh valeis
int SymTable_contains(SymTable_T oSymTable, const char *pcKey, char *type){
    SymTable_T hash_t = oSymTable;
    struct List *bucket_head;
    struct List *traversal_ptr;
    struct List *ptr;
    unsigned int node_hash;
    int found = 0;
    int i = 0, flag = 0;
    assert(oSymTable != NULL && pcKey != NULL);
    
    while(i < LIBFUNCNUM){
        if(!strcmp(pcKey, lib_funcs[i])){
            printf("\n\t(!) Error: Name can not be the same as library functions. [%s]\n\n", pcKey);
            return 1;
        }
        i++;
    }
    /*Find key's bucket*/
    node_hash = SymTable_hash(pcKey);
    /*Find bucket's head of the list*/
    bucket_head = hash_t->nodes[node_hash];


    if(!strcmp(type, "var")){
        if(find_var_bypass_func(pcKey) == -1) return 1;
        for(int i = cur_scope; i >= 0; i--){
            ptr = scope_arr[i];
            while(ptr != NULL){
                if(!strcmp(pcKey, ptr->pcKey)){
                    if(((SymbolTableEntry *)ptr->pvValue)->isActive == 1){
                        found = 1;
                    }
                }
                ptr = ptr->next;
            }
        }
    }
    else if(!strcmp(type, "func")){
        ptr = scope_arr[0];
        while(ptr != NULL){
            if(!strcmp(pcKey, ptr->pcKey)){
                if(((SymbolTableEntry *)ptr->pvValue)->isActive == 1){
                    found = 1;
                    printf("\n\t(!) Error: This function already exists as a function or variable. [%s]\n\n", pcKey);
                }
            }
            ptr = ptr->next;
        }
    }
    else if(!strcmp(type, "local_var")){
        ptr = scope_arr[cur_scope];
        while(ptr != NULL){
            if(!strcmp(pcKey, ptr->pcKey)){
                if(((SymbolTableEntry *)ptr->pvValue)->isActive == 1){
                    found = 1;
                }
            }
            ptr = ptr->next;
        }
    }
    else if(!strcmp(type, "formal")){
        printf("\n\n\n\nfasdfasfasdfsadfas\n\n\n\n");
        ptr = scope_arr[cur_scope];
        while(ptr != NULL){
            if(!strcmp(pcKey, ptr->pcKey)){
                if(((SymbolTableEntry *)ptr->pvValue)->isActive == 1){
                    printf("\n\t(!) Error: This formal argument has already been declared. [%s]\n\n", pcKey);
                    found = 1;
                }
            }
            ptr = ptr->next;
        }
    }
    

   

    if(found == 0) return 0;
    
    if(found == 1) return 1;





    if(!bucket_head) return 0;
    traversal_ptr = bucket_head;
    while(traversal_ptr && strcmp(traversal_ptr->pcKey,pcKey) != 0){
        traversal_ptr = traversal_ptr->next;
    }
    if(!traversal_ptr) return 0;
    return 1;
}


// x = y = 1; //new variables x, y{
// {
//     x = 2; //ok, refers to global x
//     a = 3; //new var a in scope 1
//     function f (z) {
//         x = 4; //ok, refers to global x 
//         a = 5; //error: cannot access  //a in scope 1
//         y = 6; //ok, refers to global y
//     }
// }
// scope_arr[0] = var y,x
// scope_arr[1] = func f,var a, var x
// scope_arr[2] = var z

int find_var_bypass_func(const char *pcKey){
    int found_func = 0;
    struct List *ptr;
    for(int i = cur_scope-1 ; i > 0 ; i--){
        ptr = scope_arr[i];
        while(ptr){
            if( ( ((SymbolTableEntry *)ptr->pvValue)->type == 3 || ((SymbolTableEntry *)ptr->pvValue)->type == 4 )  && ((SymbolTableEntry *)ptr->pvValue)->isActive == 1){
                found_func = 1;
            }
            else if(!strcmp(ptr->pcKey,pcKey) && ((SymbolTableEntry *)ptr->pvValue)->isActive == 1 && found_func == 1){
                printf("\n\t(!) Error: cannot access variable %s in scope %d.\n\n", pcKey, i);
                return -1;
            }
            ptr = ptr->next;
        }
        found_func = 0;
    }

    return 0;
}

void *SymTable_get(SymTable_T oSymTable, const char *pcKey){
    SymTable_T hash_t = oSymTable;
    struct List *bucket_head;
    struct List *traversal_ptr;
    unsigned int node_hash;
    assert(oSymTable != NULL && pcKey != NULL);

    /*Find key's bucket*/
    node_hash = SymTable_hash(pcKey);
    /*Find bucket's head of the list*/
    bucket_head = hash_t->nodes[node_hash];
    traversal_ptr = bucket_head;

    while(traversal_ptr && strcmp(traversal_ptr->pcKey,pcKey) != 0){
        traversal_ptr = traversal_ptr->next;
    }
    if(!traversal_ptr) return NULL;

    return traversal_ptr->pvValue;
}