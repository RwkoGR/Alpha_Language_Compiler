#ifndef SCOPE_L_H
#define SCOPE_L_H

#include "symtable.h"

#define SCOPE_NUM 20

int add_node_scope_arr(struct List** scope_arr, SymbolTableEntry * symTableObj );
void print_nodes_scope_arr(struct List** scope_arr);
void hide_scope(struct List** scope_arr, unsigned int scope);

struct List** create_scope_arr(void);

#endif