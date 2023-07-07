---
sidebar_position: 6
---

# User

## User info

Get information about a user specified by their DID.

```dart
final userInfo = await client.userInfo(did);
```

## Register

Register user by did and password.

```dart
final res = await client.register(did, password);
```

## Private Key

Retrieve PrivateKey by did and password.

```dart
final privateKey = await client.retrievePrivateKey(did, password);
```

## Get connected user by DID and password

```dart
final user = await client.userWithDIDAndPassword(did, password);
```

## Get connected user by DID and privateKey

```dart
final user = await client.userWithDIDAndPrivateKey(did, privateKey);
```
