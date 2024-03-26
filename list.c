#include "list.h"

int add_node(alpha_token_t **list_head,  unsigned int numline, unsigned int numToken, char *content, char *category, char *type, char *additional_info){
    alpha_token_t *new_node = malloc(sizeof(alpha_token_t));

    if (new_node == NULL) return 0;

    new_node->next = NULL;
    new_node->numline = numline;
    new_node->numToken = numToken;
    char *ptr = malloc(strlen(content) + 1);
    ptr = strcpy(ptr, content);
    new_node->content = ptr;
    new_node->category = category;
    if(!strcmp(category,"CONST_INT") || !strcmp(category, "CONST_REAL")){
        new_node->type = ptr;
    }else{
        new_node->type = type;
    }
    new_node->additional_info = additional_info;
    
    if(*list_head == NULL){
        *list_head = new_node;
    }
    else{
        alpha_token_t *current = *list_head;
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = new_node;
    }
}


// void print_list(list_t *list_head) {
//     struct list *ptr = list_head;

//     while (ptr != NULL) {
//         printf("vallue: %d \n", *(int *)(ptr->data_struct));
//         if(ptr->next == NULL) break;
//         ptr = ptr->next;
//     }
    
//     printf("\nprint them backwords!!!\n");
//     while (ptr != NULL){
//         printf("vallue: %d \n", *(int *)(ptr->data_struct));
//         ptr = ptr->prev;
//     }
// }





// int delete_node(alpha_token_t **list_head, void *data_struct){
//     alpha_token_t *current = *list_head;
//     alpha_token_t *prev = NULL;
//     while (current != NULL) {
//         if (current->data_struct == data_struct) {
//             if (prev == NULL) {
//                 *list_head = current->next;
//             } 
//             else {
//                 prev->next = current->next;
//                 if(current->next != NULL)
//                     current->next->prev = prev;
//             }
//             free(current);
//             return 1;
//         }
//         prev = current;
//         current = current->next;
//     }
//     return 0;
// }


// int main(){
//     list_t *list_head = NULL;
//     int a = 1;
//     int b = 4;
//     int c = 7;
//     int d = 13;
//     int e = -5;
    
    
//     add_node(&list_head,&a);
//     add_node(&list_head,&b);
//     add_node(&list_head,&c);
//     add_node(&list_head,&d);
//     add_node(&list_head,&e);
//     print_list(list_head);
//     search(list_head, &c);
//     delete_node(&list_head, &c);
//     search(list_head, &c);
//     print_list(list_head);

//     return 0;
// }