#[tokio::main(flavor = "current_thread")]
pub async fn initial_user(user_id: String) -> anyhow::Result<(), String> {
    let user = web3mq_mls::initial_user(&user_id).await?;
    Ok(user)
}

#[tokio::main(flavor = "current_thread")]
pub async fn register_user(user_id: String) -> anyhow::Result<String, String> {
    let user = web3mq_mls::register_user(&user_id).await?;
    return user;
}

#[tokio::main(flavor = "current_thread")]
pub async fn is_mls_group(user_id: String, group_id: String) -> Result<bool, String> {
    let is_mls_group = web3mq_mls::is_mls_group(&user_id, group_id).await?;
    return Ok(is_mls_group);
}

#[tokio::main(flavor = "current_thread")]
pub async fn create_group(user_id: String, group_id: String) -> Result<String, String> {
    let group = web3mq_mls::create_group(&user_id, group_id).await?;
    return Ok(group);
}

#[tokio::main(flavor = "current_thread")]
pub async fn sync_mls_state(user_id: String, group_ids: Vec<String>) -> Result<(), String> {
    let _ = web3mq_mls::sync_mls_state(&user_id, group_ids).await?;
    return Ok(());
}

#[tokio::main(flavor = "current_thread")]
pub async fn can_add_member_to_group(user_id: String, target_user_id: String) -> Result<bool, String> {
    let can_add_member_to_group =
        web3mq_mls::can_add_member_to_group(&user_id, target_user_id).await?;
    return Ok(can_add_member_to_group);
}

#[tokio::main(flavor = "current_thread")]
pub async fn add_member_to_group(
    user_id: String,
    member_user_id: String,
    group_id: String,
) -> Result<(), String> {
    let _ = web3mq_mls::add_member_to_group(&user_id, member_user_id, group_id).await?;
    return Ok(());
}

#[tokio::main(flavor = "current_thread")]
pub async fn mls_encrypt_msg(user_id: String, msg: String, group_id: String) -> Result<String, String> {
    let msg = web3mq_mls::mls_encrypt_msg(&user_id, msg, group_id).await?;
    return Ok(msg);
}

#[tokio::main(flavor = "current_thread")]
pub async fn mls_decrypt_msg(
    user_id: String,
    msg: String,
    sender_user_id: String,
    group_id: String,
) -> Result<String, String> {
    let msg = web3mq_mls::mls_decrypt_msg(&user_id, msg, sender_user_id, group_id).await?;
    return Ok(msg);
}

#[tokio::main(flavor = "current_thread")]
pub async fn handle_mls_group_event(user_id: String, msg_bytes: Vec<u8>) -> Result<(), String> {
    let _ = web3mq_mls::handle_mls_group_event(&user_id, msg_bytes).await?;
    return Ok(());
}
