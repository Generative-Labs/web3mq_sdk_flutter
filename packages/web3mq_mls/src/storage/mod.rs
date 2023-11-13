// public
pub mod persistent_crypto;

// pub mod rusqlite;

mod persistent_key_store;

#[cfg(test)]
mod crypto_store_tests {
    use openmls::{
        prelude::{Credential, CredentialType, CredentialWithKey, CryptoConfig, KeyPackage},
        versions::ProtocolVersion,
    };
    use openmls_traits::{
        key_store::OpenMlsKeyStore,
        types::{Ciphersuite, SignatureScheme},
        OpenMlsProvider,
    };

    use openmls_basic_credential::SignatureKeyPair;

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
