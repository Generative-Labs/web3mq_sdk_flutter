fn add_numbers(a: i32, b: i32) -> i32 {
    a + b
}
use web3mq_mls_group::service::user::User;
pub fn greet() -> String {
    "Hello from Rust! 🦀".into()
}

/// Initial user.
///
/// # Arguments
///
/// * `user_id` - The web3mq User Id.
///
/// # Returns load or create new.
///
#[tokio::main(flavor = "current_thread")]
pub async fn inital_user(user_id: String) -> anyhow::Result<bool> {
    let user = User::load(user_id.clone());
    match user {
        Ok(_) => Ok(true),
        Err(_) => {
            let mut user = User::new(user_id.clone());
            user.enable_auto_save();
            user.save();
            user.register().await;
            return Ok(false);
        }
    }
}

#[tokio::main(flavor = "current_thread")]
pub async fn register(user_id: String) -> Result<String, String> {
    let user = User::load(user_id.clone()).expect("Error loading user");
    return user.register().await;
}

pub fn get_file_path_readable(user_id: String) -> String {
    return User::get_file_path_readable(user_id);
}

///
pub fn get_groups(user_id: String) -> anyhow::Result<Vec<String>> {
    let user = User::load(user_id.clone()).expect("Error loading user");
    let groups = user.get_groups();
    Ok(groups)
}

/// Create a group
pub fn create_group(user_id: String, group_id: String) -> anyhow::Result<Vec<String>> {
    let mut user = User::load(user_id.clone()).expect("Error loading user");
    let groups = user
        .create_group(group_id.to_string())
        .expect("Error creating group");
    Ok(groups)
}

#[tokio::main(flavor = "current_thread")]
pub async fn update(user_id: String) -> anyhow::Result<()> {
    let mut user = User::load(user_id.clone()).expect("Error loading user");
    let _ = user.update().await;
    Ok(())
}

#[tokio::main(flavor = "current_thread")]
pub async fn can_add_member_to_group(user_id: String, target_user_id: String) -> bool {
    let user = User::load(user_id.clone()).expect("Error loading user");
    return user.can_invite(target_user_id).await;
}

#[tokio::main(flavor = "current_thread")]
pub async fn add_member_to_group(
    user_id: String,
    member_user_id: String,
    group_id: String,
) -> anyhow::Result<()> {
    let mut user = User::load(user_id.clone()).expect("Error loading user");
    let _ = user.add_member_to_group(member_user_id, group_id).await;
    Ok(())
}

pub fn send_msg(user_id: String, msg: String, group_id: String) -> anyhow::Result<String, String> {
    let mut user = User::load(user_id.clone()).expect("Error loading user");
    return user.send_msg(&msg, group_id);
}

pub fn read_msg(
    msg: String,
    user_id: String,
    sender_user_id: String,
    group_id: String,
) -> anyhow::Result<String> {
    let user = User::load(user_id.clone()).expect("Error loading user");
    // convert msg to Vec<u8>
    let msg = user
        .read_msg(msg, sender_user_id, group_id)
        .expect("Error reading message");
    Ok(msg)
}

///
pub fn get_all_messages(user_id: String, group_id: String) -> anyhow::Result<Vec<String>> {
    let user = User::load(user_id.clone()).expect("Error loading user");
    let messages = user
        .get_all_messages_self(group_id)
        .expect("Error fetching messages");
    Ok(messages)
}

#[tokio::main(flavor = "current_thread")]
pub async fn leave_group(user_id: String, group_id: String) -> anyhow::Result<(), String> {
    let mut user = User::load(user_id.clone()).expect("Error loading user");
    return user.leave_group(group_id).await;
}
