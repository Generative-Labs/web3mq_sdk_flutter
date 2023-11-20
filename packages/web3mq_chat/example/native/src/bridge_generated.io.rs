use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_greet(port_: i64) {
    wire_greet_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_inital_user(port_: i64, user_id: *mut wire_uint_8_list) {
    wire_inital_user_impl(port_, user_id)
}

#[no_mangle]
pub extern "C" fn wire_register(port_: i64, user_id: *mut wire_uint_8_list) {
    wire_register_impl(port_, user_id)
}

#[no_mangle]
pub extern "C" fn wire_get_file_path_readable(port_: i64, user_id: *mut wire_uint_8_list) {
    wire_get_file_path_readable_impl(port_, user_id)
}

#[no_mangle]
pub extern "C" fn wire_get_groups(port_: i64, user_id: *mut wire_uint_8_list) {
    wire_get_groups_impl(port_, user_id)
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
pub extern "C" fn wire_update(port_: i64, user_id: *mut wire_uint_8_list) {
    wire_update_impl(port_, user_id)
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
pub extern "C" fn wire_send_msg(
    port_: i64,
    user_id: *mut wire_uint_8_list,
    msg: *mut wire_uint_8_list,
    group_id: *mut wire_uint_8_list,
) {
    wire_send_msg_impl(port_, user_id, msg, group_id)
}

#[no_mangle]
pub extern "C" fn wire_read_msg(
    port_: i64,
    msg: *mut wire_uint_8_list,
    user_id: *mut wire_uint_8_list,
    sender_user_id: *mut wire_uint_8_list,
    group_id: *mut wire_uint_8_list,
) {
    wire_read_msg_impl(port_, msg, user_id, sender_user_id, group_id)
}

#[no_mangle]
pub extern "C" fn wire_get_all_messages(
    port_: i64,
    user_id: *mut wire_uint_8_list,
    group_id: *mut wire_uint_8_list,
) {
    wire_get_all_messages_impl(port_, user_id, group_id)
}

#[no_mangle]
pub extern "C" fn wire_leave_group(
    port_: i64,
    user_id: *mut wire_uint_8_list,
    group_id: *mut wire_uint_8_list,
) {
    wire_leave_group_impl(port_, user_id, group_id)
}

// Section: allocate functions

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
