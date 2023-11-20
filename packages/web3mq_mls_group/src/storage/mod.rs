// public
pub mod persistent_crypto;

// pub mod rusqlite;

mod persistent_key_store;

#[cfg(test)]
mod crypto_store_tests {

    use openmls::{
        framing::{MlsMessageIn, MlsMessageInBody, ProcessedMessageContent, ProtocolMessage},
        group::{MlsGroup, MlsGroupConfig},
        prelude::{Credential, CredentialType, CredentialWithKey, CryptoConfig, KeyPackage},
        versions::ProtocolVersion,
    };
    use openmls_traits::{
        key_store::OpenMlsKeyStore,
        types::{Ciphersuite, SignatureScheme},
        OpenMlsProvider,
    };

    use openmls_basic_credential::SignatureKeyPair;
    use tls_codec::{Deserialize, Serialize};

    use crate::service::backend::Backend;

    use super::persistent_crypto::OpenMlsRustPersistentCrypto;

    #[test]
    fn test_write_and_read_and_delete() {
        let ciphersuite = Ciphersuite::MLS_128_DHKEMX25519_AES128GCM_SHA256_Ed25519;
        let backend = &OpenMlsRustPersistentCrypto::default();
        let (alice_credential_with_key, alice_signer) = generate_credential_with_key(
            "alice".into(),
            CredentialType::Basic,
            ciphersuite.signature_algorithm(),
            backend,
        );

        let alice_key_package = generate_key_package(
            ciphersuite,
            backend,
            &alice_signer,
            alice_credential_with_key,
        );

        let binding = alice_key_package
            .clone()
            .hash_ref(backend.crypto())
            .expect("Error hash ref");

        let cache_key = binding.as_slice();

        let loaded_key_package: KeyPackage = backend
            .key_store()
            .read(cache_key)
            .expect("Error reading key package from key store.");

        assert_eq!(loaded_key_package, alice_key_package);

        // delete the key package
        let _ = backend
            .key_store()
            .delete::<openmls::key_packages::KeyPackage>(cache_key);

        let loaded_key_package: Option<KeyPackage> = backend.key_store().read(cache_key);
        assert!(loaded_key_package.is_none());
    }

    #[test]
    fn test_message_encrypt() {
        let ciphersuite = Ciphersuite::MLS_128_DHKEMX25519_AES128GCM_SHA256_Ed25519;
        let backend_alice = &OpenMlsRustPersistentCrypto::default();
        let (alice_credential_with_key, alice_signer) = generate_credential_with_key(
            "alice".into(),
            CredentialType::Basic,
            ciphersuite.signature_algorithm(),
            backend_alice,
        );

        let alice_key_package = generate_key_package(
            ciphersuite,
            backend_alice,
            &alice_signer,
            alice_credential_with_key.clone(),
        );

        let group_config = MlsGroupConfig::builder()
            .use_ratchet_tree_extension(true)
            .build();

        let mut mls_group = MlsGroup::new(
            backend_alice,
            &alice_signer,
            &group_config,
            alice_credential_with_key.clone(),
        )
        .expect("Error creating group");

        let backend_bob = &OpenMlsRustPersistentCrypto::default();
        let (bob_credential_with_key, bob_signer) = generate_credential_with_key(
            "bob".into(),
            CredentialType::Basic,
            ciphersuite.signature_algorithm(),
            backend_bob,
        );

        let bob_key_package = generate_key_package(
            ciphersuite,
            backend_bob,
            &bob_signer,
            bob_credential_with_key.clone(),
        );

        let (mls_message_out, welcome, group_info) = mls_group
            .add_members(backend_alice, &alice_signer, &[bob_key_package])
            .expect("Could not add members.");

        mls_group
            .merge_pending_commit(backend_alice)
            .expect("error merging pending commit");

        let serialized_welcome = welcome
            .tls_serialize_detached()
            .expect("Error serializing welcome");

        let mls_message_in = MlsMessageIn::tls_deserialize(&mut serialized_welcome.as_slice())
            .expect("An unexpected error occurred.");

        let welcome = match mls_message_in.extract() {
            MlsMessageInBody::Welcome(welcome) => welcome,
            // We know it's a welcome message, so we ignore all other cases.
            _ => unreachable!("Unexpected message type."),
        };

        let bob_group = MlsGroup::new_from_welcome(backend_bob, &group_config, welcome, None)
            .expect("Error joining group from Welcome");

        let message_out = mls_group
            .create_message(backend_alice, &alice_signer, "hello".as_bytes())
            .expect("Error creating message");

        let mls_message_in = MlsMessageIn::tls_deserialize(&mut serialized_welcome.as_slice())
            .expect("An unexpected error occurred.");

        let msg_bytes_0: Vec<u8> = message_out
            .tls_serialize_detached()
            .expect("Errror serializing message");
        print!(" >>> send: {:?}", msg_bytes_0);

        let mls_message = MlsMessageIn::tls_deserialize_exact(msg_bytes_0)
            .expect("Could not deserialize message.");

        let protocol_message: ProtocolMessage = mls_message.into();

        print!(" >>> protocol_message: {:?}", protocol_message);

        // get the MlsGroup from groups
        // let (mls_message_out, welcome, group_info)
        // if throw error, print it out
        let processed_message = mls_group
            .process_message(backend_alice, protocol_message)
            .expect("Error processing message");

        if let ProcessedMessageContent::ApplicationMessage(application_message) =
            processed_message.into_content()
        {
            // bytes to string
            let application_message = String::from_utf8(application_message.into_bytes()).unwrap();
            print!(" >>> application_message: {:?}", application_message);
        } else {
            print!("Error processing unverified message")
        }
    }

    #[test]
    fn test() {
        let client_id: &[u8] = &[
            117, 115, 101, 114, 58, 53, 55, 53, 50, 100, 102, 102, 55, 99, 100, 51, 97, 49, 51,
            100, 51, 97, 51, 56, 55, 51, 50, 50, 51, 98, 57, 53, 51, 53, 101, 57, 49, 51, 53, 97,
            56, 98, 54, 50, 99, 52, 49, 99, 101, 51, 97, 50, 101, 101, 98, 54, 52, 49, 53, 53, 102,
        ];
        let result = base64::encode_config(client_id, base64::URL_SAFE);
        print!("result: {:?}", result);
    }

    #[tokio::test]
    async fn test_backend_client_list() {
        let backend = Backend::default();
        let clients = backend.list_clients().await;
        print!("clients: {:?}", clients);

        let client_id: &[u8] = &[
            117, 115, 101, 114, 58, 53, 55, 53, 50, 100, 102, 102, 55, 99, 100, 51, 97, 49, 51,
            100, 51, 97, 51, 56, 55, 51, 50, 50, 51, 98, 57, 53, 51, 53, 101, 57, 49, 51, 53, 97,
            56, 98, 54, 50, 99, 52, 49, 99, 101, 51, 97, 50, 101, 101, 98, 54, 52, 49, 53, 53, 102,
        ];
        let client = backend.consume_key_package(client_id).await;
        print!("\nclient: {:?}", client);
    }

    // #[test]
    // fn test_group_persistent() {
    //     let mut user = User::load("Alice".to_string()).expect("Error loading user");
    //     user.enable_auto_save();
    //     user.create_group("group_id".to_string());

    //     let group = user.groups.borrow_mut().get("group_id").unwrap();
    //     group.borrow_mut().conversation.add(ConversationMessage::new(), crypted_string);
    //     // user.groups
    //     //     .borrow_mut()
    //     //     .insert("test".to_string(), Group::default());
    // }

    // A helper to create and store credentials.
    fn generate_credential_with_key(
        identity: Vec<u8>,
        credential_type: CredentialType,
        signature_algorithm: SignatureScheme,
        backend: &impl OpenMlsProvider,
    ) -> (CredentialWithKey, SignatureKeyPair) {
        let credential = Credential::new(identity, credential_type).unwrap();
        let signature_keys = SignatureKeyPair::new(signature_algorithm)
            .expect("Error generating a signature key pair.");
        // Store the signature key into the key store so OpenMLS has access
        // to it.
        signature_keys
            .store(backend.key_store())
            .expect("Error storing signature keys in key store.");

        (
            CredentialWithKey {
                credential,
                signature_key: signature_keys.public().into(),
            },
            signature_keys,
        )
    }

    // A helper to create key package bundles.
    fn generate_key_package(
        ciphersuite: Ciphersuite,
        backend: &impl OpenMlsProvider,
        signer: &SignatureKeyPair,
        credential_with_key: CredentialWithKey,
    ) -> KeyPackage {
        // Create the key package
        KeyPackage::builder()
            .build(
                CryptoConfig {
                    ciphersuite,
                    version: ProtocolVersion::default(),
                },
                backend,
                signer,
                credential_with_key,
            )
            .unwrap()
    }
}
