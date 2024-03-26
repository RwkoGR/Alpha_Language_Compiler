#include <stdio.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct alpha_token_t{
  unsigned int          numline;
  unsigned int          numToken;
  char                  *content;
  char                  *category;
  char                  *type;
  char                  *additional_info;
  struct alpha_token_t  *next;
};
typedef struct alpha_token_t alpha_token_t;

int add_node(alpha_token_t **list_head, unsigned int numline, unsigned int numToken, char *content, char *category, char *type, char *additional_info);
// int search(alpha_token_t *list_head, void *data_struct);
// int delete_node(list_t **list_head, void *data_struct);
// void print_list(list_t *list_head);