import 'package:flutter/material.dart' show immutable;

enum UserStatus { member, admin }

extension UserStatusExtension on UserStatus {
  static UserStatus fromJson(String? userStatus) {
    switch (userStatus) {
      case 'admin':
        return UserStatus.admin;
      case 'member':
      default:
        return UserStatus.member;
    }
  }
}

@immutable
class User {
  const User(
    this.id,
    this.email,
    this.displayName,
    this.userStatus,
  );

  User.fromJson(
    this.id,
    this.email,
    this.displayName,
    Map<String, dynamic>? parsedJson,
  ) : userStatus =
            UserStatusExtension.fromJson(parsedJson?['userStatus'] as String?);

  final String id, email;
  final String? displayName;
  final UserStatus userStatus;
}
