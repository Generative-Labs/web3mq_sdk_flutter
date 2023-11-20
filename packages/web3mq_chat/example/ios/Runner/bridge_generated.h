#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
typedef struct _Dart_Handle* Dart_Handle;

typedef struct DartCObject DartCObject;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct DartCObject *WireSyncReturn;

void store_dart_post_cobject(DartPostCObjectFnType ptr);

Dart_Handle get_dart_object(uintptr_t ptr);

void drop_dart_object(uintptr_t ptr);

uintptr_t new_dart_opaque(Dart_Handle handle);

intptr_t init_frb_dart_api_dl(void *obj);

void wire_greet(int64_t port_);

void wire_inital_user(int64_t port_, struct wire_uint_8_list *user_id);

void wire_register(int64_t port_, struct wire_uint_8_list *user_id);

void wire_get_file_path_readable(int64_t port_, struct wire_uint_8_list *user_id);

void wire_get_groups(int64_t port_, struct wire_uint_8_list *user_id);

void wire_create_group(int64_t port_,
                       struct wire_uint_8_list *user_id,
                       struct wire_uint_8_list *group_id);

void wire_update(int64_t port_, struct wire_uint_8_list *user_id);

void wire_can_add_member_to_group(int64_t port_,
                                  struct wire_uint_8_list *user_id,
                                  struct wire_uint_8_list *target_user_id);

void wire_add_member_to_group(int64_t port_,
                              struct wire_uint_8_list *user_id,
                              struct wire_uint_8_list *member_user_id,
                              struct wire_uint_8_list *group_id);

void wire_send_msg(int64_t port_,
                   struct wire_uint_8_list *user_id,
                   struct wire_uint_8_list *msg,
                   struct wire_uint_8_list *group_id);

void wire_read_msg(int64_t port_,
                   struct wire_uint_8_list *msg,
                   struct wire_uint_8_list *user_id,
                   struct wire_uint_8_list *sender_user_id,
                   struct wire_uint_8_list *group_id);

void wire_get_all_messages(int64_t port_,
                           struct wire_uint_8_list *user_id,
                           struct wire_uint_8_list *group_id);

void wire_leave_group(int64_t port_,
                      struct wire_uint_8_list *user_id,
                      struct wire_uint_8_list *group_id);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

void free_WireSyncReturn(WireSyncReturn ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_greet);
    dummy_var ^= ((int64_t) (void*) wire_inital_user);
    dummy_var ^= ((int64_t) (void*) wire_register);
    dummy_var ^= ((int64_t) (void*) wire_get_file_path_readable);
    dummy_var ^= ((int64_t) (void*) wire_get_groups);
    dummy_var ^= ((int64_t) (void*) wire_create_group);
    dummy_var ^= ((int64_t) (void*) wire_update);
    dummy_var ^= ((int64_t) (void*) wire_can_add_member_to_group);
    dummy_var ^= ((int64_t) (void*) wire_add_member_to_group);
    dummy_var ^= ((int64_t) (void*) wire_send_msg);
    dummy_var ^= ((int64_t) (void*) wire_read_msg);
    dummy_var ^= ((int64_t) (void*) wire_get_all_messages);
    dummy_var ^= ((int64_t) (void*) wire_leave_group);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturn);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    dummy_var ^= ((int64_t) (void*) get_dart_object);
    dummy_var ^= ((int64_t) (void*) drop_dart_object);
    dummy_var ^= ((int64_t) (void*) new_dart_opaque);
    return dummy_var;
}
