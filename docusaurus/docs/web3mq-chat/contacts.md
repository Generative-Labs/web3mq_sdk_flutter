---
sidebar_position: 4
---

# Contacts

## Get User Followings

Use the `followings` method to get a list of users that the current user is following.

```dart
final page = await client.followings(pagination);
```

## Get User Followers

Use the `followers` method to get a list of users who are following the current user.

```dart
final page = await client.followers(pagination);
```

## Follow User

Use the `follow` method to follow a user.

```dart
await client.follow(userId);
```

## Unfollow User

Use the `unfollow` method to unfollow a user.

```dart
await client.unfollow(userId);
```
