use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_initial_user(port_: i64, user_id: *mut wire_uint_8_list) {
    wire_initial_user_impl(port_, user_id)
}

#[no_mangle]
pub extern "C" fn wire_register_user(port_: i64, user_id: *mut wire_uint_8_list) {
    wire_register_user_impl(port_, user_id)
}

#[no_mangle]
pub extern "C" fn wire_is_mls_group(
    port_: i64,
    user_id: *mut wire_uint_8_list,
    group_id: *mut wire_uint_8_list,
) {
    wire_is_mls_group_impl(port_, user_id, group_id)
}

#[no_mangle]
pub extern "C" fn wire_create_group(
    port_: i64,
    user_id: *mut wire_uint_8_list,
    group_id: *mut wire_uint_8_list,
) {
    wire_create_group_impl(port_, user_id, group_id)
}

#[no_mangle]
pub extern "C" fn wire_sync_mls_state(
    port_: i64,
    user_id: *mut wire_uint_8_list,
    group_ids: *mut wire_StringList,
) {
    wire_sync_mls_state_impl(port_, user_id, group_ids)
}

#[no_mangle]
pub extern "C" fn wire_can_add_member_to_group(
    port_: i64,
    user_id: *mut wire_uint_8_list,
    target_user_id: *mut wire_uint_8_list,
) {
    wire_can_add_member_to_group_impl(port_, user_id, target_user_id)
}

#[no_mangle]
pub extern "C" fn wire_add_member_to_group(
    port_: i64,
    user_id: *mut wire_uint_8_list,
    member_user_id: *mut wire_uint_8_list,
    group_id: *mut wire_uint_8_list,
) {
    wire_add_member_to_group_impl(port_, user_id, member_user_id, group_id)
}

#[no_mangle]
pub extern "C" fn wire_mls_encrypt_msg(
    port_: i64,
    user_id: *mut wire_uint_8_list,
    msg: *mut wire_uint_8_list,
    group_id: *mut wire_uint_8_list,
) {
    wire_mls_encrypt_msg_impl(port_, user_id, msg, group_id)
}

#[no_mangle]
pub extern "C" fn wire_mls_decrypt_msg(
    port_: i64,
    user_id: *mut wire_uint_8_list,
    msg: *mut wire_uint_8_list,
    sender_user_id: *mut wire_uint_8_list,
    group_id: *mut wire_uint_8_list,
) {
    wire_mls_decrypt_msg_impl(port_, user_id, msg, sender_user_id, group_id)
}

#[no_mangle]
pub extern "C" fn wire_handle_mls_group_event(
    port_: i64,
    user_id: *mut wire_uint_8_list,
    msg_bytes: *mut wire_uint_8_list,
) {
    wire_handle_mls_group_event_impl(port_, user_id, msg_bytes)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_StringList_0(len: i32) -> *mut wire_StringList {
    let wrap = wire_StringList {
        ptr: support::new_leak_vec_ptr(<*mut wire_uint_8_list>::new_with_null_ptr(), len),
        len,
    };
    support::new_leak_box_ptr(wrap)
}

#[no_mangle]
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
    }
}
impl Wire2Api<Vec<String>> for *mut wire_StringList {
    fn wire2api(self) -> Vec<String> {
        let vec = unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        };
        vec.into_iter().map(Wire2Api::wire2api).collect()
    }
}

impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
    fn wire2api(self) -> Vec<u8> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}
// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_StringList {
    ptr: *mut *mut wire_uint_8_list,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_8_list {
    ptr: *mut u8,
    len: i32,
}

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
    fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
    fn new_with_null_ptr() -> Self {
        std::ptr::null_mut()
    }
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
    unsafe {
        let _ = support::box_from_leak_ptr(ptr);
    };
}