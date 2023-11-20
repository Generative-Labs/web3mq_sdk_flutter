use std::collections::HashMap;

use serde::{Deserialize, Serialize};

/// A conversation is a list of messa
/// ges (strings).
#[derive(Default, Debug, Serialize, Deserialize, Clone)]
pub struct Conversation {
    messages: Vec<ConversationMessage>,
    messages_self: HashMap<String, String>,
}

impl Conversation {
    /// Add a message string to the conversation list.
    pub fn add(
        &mut self,
        conversation_message: ConversationMessage,
        crypted_string: Option<String>,
    ) {
        if crypted_string.is_some() {
            self.messages_self.insert(
                crypted_string.unwrap(),
                conversation_message.clone().message,
            );
        }
        self.messages.push(conversation_message);
    }

    ///
    pub fn get_self_message(&self, crypted_string: String) -> Option<String> {
        self.messages_self.get(&crypted_string).cloned()
    }

    ///
    pub fn get_all_messages(&self) -> Vec<String> {
        self.messages_self.keys().cloned().collect::<Vec<String>>()
    }

    /// Get a list of messages in the conversation.
    /// The function returns the `last_n` messages.
    #[allow(dead_code)]
    pub fn get(&self, last_n: usize) -> Option<&[ConversationMessage]> {
        let num_messages = self.messages.len();
        let start = if last_n > num_messages {
            0
        } else {
            num_messages - last_n
        };
        self.messages.get(start..num_messages)
    }
}

///
#[derive(Debug, PartialEq, Serialize, Deserialize, Clone)]
pub struct ConversationMessage {
    author: String,
    message: String,
}

impl ConversationMessage {
    pub fn new(message: String, author: String) -> ConversationMessage {
        Self { author, message }
    }

    pub fn author(&self) -> String {
        self.author.clone()
    }

    pub fn message(&self) -> String {
        self.message.clone()
    }

    pub fn set_author(&mut self, author: String) {
        self.author = author;
    }

    pub fn set_message(&mut self, message: String) {
        self.message = message;
    }
}
