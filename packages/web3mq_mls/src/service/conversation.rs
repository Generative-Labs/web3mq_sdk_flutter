use serde::{Deserialize, Serialize};
use wasm_bindgen::prelude::wasm_bindgen;

/// A conversation is a list of messages (strings).
#[derive(Default, Debug, Serialize, Deserialize)]
pub struct Conversation {
    messages: Vec<ConversationMessage>,
}

#[wasm_bindgen]
#[derive(Debug, PartialEq, Serialize, Deserialize, Clone)]
pub struct ConversationMessage {
    author: String,
    message: String,
}

impl Conversation {
    /// Add a message string to the conversation list.
    pub fn add(&mut self, conversation_message: ConversationMessage) {
        self.messages.push(conversation_message)
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

#[wasm_bindgen]
impl ConversationMessage {
    #[wasm_bindgen(constructor)]
    pub fn new(author: String, message: String) -> ConversationMessage {
        Self { author, message }
    }

    #[wasm_bindgen(getter)]
    pub fn author(&self) -> String {
        self.author.clone()
    }

    #[wasm_bindgen(getter)]
    pub fn message(&self) -> String {
        self.message.clone()
    }

    #[wasm_bindgen(setter)]
    pub fn set_author(&mut self, author: String) {
        self.author = author;
    }

    #[wasm_bindgen(setter)]
    pub fn set_message(&mut self, message: String) {
        self.message = message;
    }
}
