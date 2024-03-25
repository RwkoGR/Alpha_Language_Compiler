#ifndef SYMTABLE
#define SYMTABLE

#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#define HASH_MULTIPLIER 65599
#define BUCKETS 509
#define LIBFUNCNUM 12


typedef struct Variable { 
    const char *name; 
    unsigned int scope; 
    unsigned int line; 
} Variable; 

typedef struct Function { 
    const char *name; 
    //List of arguments 
    char **arg_list;
    unsigned int scope; 
    unsigned int line; 
} Function; 

enum SymbolType { 
    GLOBAL,  LOCAL, FORMAL, 
    USERFUNC, LIBFUNC 
}; 

typedef struct SymbolTableEntry { 
    int isActive; 
    union { 
        Variable *varVal; 
        Function *funcVal;
    } value; 
    enum SymbolType type; 
} SymbolTableEntry;

struct List{
    char *pcKey;
    void *pvValue;
    struct List *next;
};

struct SymTable{
    struct List** nodes;
    unsigned int buckets;
    unsigned int count;
};

typedef struct SymTable *SymTable_T;

SymTable_T SymTable_new(void);
void SymTable_free(SymTable_T oSymTable);
unsigned int SymTable_getLength(SymTable_T oSymTable);
int SymTable_put(SymTable_T oSymTable, const char *pcKey, const void *pvValue, char *type, char *args);
void SymTable_print(SymTable_T oSymTable);
int SymTable_remove(SymTable_T oSymTable, const char *pcKey);
int SymTable_contains(SymTable_T oSymTable, const char *pcKey);
void *SymTable_get(SymTable_T oSymTable, const char *pcKey);

#endif

