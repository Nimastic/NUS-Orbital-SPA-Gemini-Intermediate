import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable 
class AuthUser {
  final String email;
  final bool isEmailVerified;
  final String id;
  final String userName;

  const AuthUser({
    required this.email,
    required this.isEmailVerified,
    required this.id,
    required this.userName
  });

  factory AuthUser.fromFirebase(User user) => 
      AuthUser(
        email: user.email!,
        isEmailVerified: user.emailVerified, 
        id: user.uid, userName: 
        user.displayName ?? "User"
      );
}