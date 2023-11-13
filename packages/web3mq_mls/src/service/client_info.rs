use std::collections::HashSet;

use openmls::prelude::*;
use tls_codec::{
    TlsByteSliceU16, TlsByteVecU16, TlsByteVecU32, TlsByteVecU8, TlsDeserialize, TlsSerialize,
    TlsSize, TlsVecU32,
};

#[derive(Debug, Default, Clone)]
pub struct ClientInfo {
    pub client_name: String,
    pub key_packages: ClientKeyPackages,
    /// map of reserved key_packages [group_id, key_package_hash]
    pub reserved_key_pkg_hash: HashSet<Vec<u8>>,
    pub id: Vec<u8>,
}

#[derive(
    Debug,
    Default,
    Clone,
    PartialEq,
    TlsSerialize,
    TlsDeserialize,
    TlsSize,
    serde::Serialize,
    serde::Deserialize,
)]
pub struct ClientKeyPackages(pub TlsVecU32<(TlsByteVecU8, KeyPackageIn)>);

impl ClientInfo {
    pub fn new(client_name: String, mut key_packages: Vec<(Vec<u8>, KeyPackageIn)>) -> Self {
        let key_package: KeyPackage = KeyPackage::from(key_packages[0].1.clone());
        let id = key_package.leaf_node().credential().identity().to_vec();
        Self {
            client_name,
            id,
            key_packages: ClientKeyPackages(
                key_packages
                    .drain(..)
                    .map(|(e1, e2)| (e1.into(), e2))
                    .collect::<Vec<(TlsByteVecU8, KeyPackageIn)>>()
                    .into(),
            ),
            reserved_key_pkg_hash: HashSet::new(),
        }
    }

    /// The identity of a client is defined as the identity of the first key
    /// package right now.
    pub fn id(&self) -> &[u8] {
        self.id.as_slice()
    }
}

/// An core group message.
/// This is an `MLSMessage` plus the list of recipients as a vector of client
/// names.
#[derive(Debug)]
pub struct GroupMessage {
    pub msg: MlsMessageIn,
    pub recipients: TlsVecU32<TlsByteVecU32>,
}

impl GroupMessage {
    /// Create a new `GroupMessage` taking an `MlsMessageIn` and slice of
    /// recipient names.
    pub fn new(msg: MlsMessageIn, recipients: &[Vec<u8>]) -> Self {
        Self {
            msg,
            recipients: recipients
                .iter()
                .map(|r| r.clone().into())
                .collect::<Vec<TlsByteVecU32>>()
                .into(),
        }
    }
}

impl tls_codec::Size for ClientInfo {
    fn tls_serialized_len(&self) -> usize {
        TlsByteSliceU16(self.client_name.as_bytes()).tls_serialized_len()
            + self.key_packages.tls_serialized_len()
    }
}

impl tls_codec::Serialize for ClientInfo {
    fn tls_serialize<W: std::io::Write>(&self, writer: &mut W) -> Result<usize, tls_codec::Error> {
        let written = TlsByteSliceU16(self.client_name.as_bytes()).tls_serialize(writer)?;
        self.key_packages.tls_serialize(writer).map(|l| l + written)
    }
}

impl tls_codec::Deserialize for ClientInfo {
    fn tls_deserialize<R: std::io::Read>(bytes: &mut R) -> Result<Self, tls_codec::Error> {
        let client_name =
            String::from_utf8_lossy(TlsByteVecU16::tls_deserialize(bytes)?.as_slice()).into();

        let mut key_packages: Vec<(TlsByteVecU8, KeyPackageIn)> =
            TlsVecU32::<(TlsByteVecU8, KeyPackageIn)>::tls_deserialize(bytes)?.into();
        let key_packages = key_packages
            .drain(..)
            .map(|(e1, e2)| (e1.into(), e2))
            .collect();
        Ok(Self::new(client_name, key_packages))
    }
}

impl tls_codec::Size for GroupMessage {
    fn tls_serialized_len(&self) -> usize {
        self.msg.tls_serialized_len() + self.recipients.tls_serialized_len()
    }
}

impl tls_codec::Serialize for GroupMessage {
    fn tls_serialize<W: std::io::Write>(&self, writer: &mut W) -> Result<usize, tls_codec::Error> {
        let written = self.msg.tls_serialize(writer)?;
        self.recipients.tls_serialize(writer).map(|l| l + written)
    }
}

impl tls_codec::Deserialize for GroupMessage {
    fn tls_deserialize<R: std::io::Read>(bytes: &mut R) -> Result<Self, tls_codec::Error> {
        let msg = MlsMessageIn::tls_deserialize(bytes)?;
        let recipients = TlsVecU32::<TlsByteVecU32>::tls_deserialize(bytes)?;
        Ok(Self { msg, recipients })
    }
}