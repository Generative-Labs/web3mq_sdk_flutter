---
sidebar_position: 3
---

# Group

## Get Group List

Use the `groups` method to get a list of groups.

```dart
final page = await client.groups(pagination: pagination);
```

## Create Group

Use the `createGroup` method to create a group.

```dart
final group = await client.createGroup(name, avatarUrl);
```

## Get Group Members

Use the `membersByGroupId` method to get a list of members in a group.

```dart
final page = await client.membersByGroupId(groupId, pagination: pagination);
```

## Invite User to Group

Use the `invite` method to invite a user to a group.

```dart
await client.invite(groupId, userIds);
```

## Get Group Info

Use the `groupInfo` method to get the information of a group.

```dart
final group = await client.groupInfo(groupId);
```

## Joining Group

Joins a group with the specified group ID.

```dart
await cleint.joinGroup('groupId');
```

## Quit Group

Quits a group with the specified group ID.

```dart
await client.quitGroup('groupId');
```

## Updating group permissions

Updates the group permissions for the specified group.

```dart
await client.updateGroupPermissions('groupId', GroupPermission.public)
```
