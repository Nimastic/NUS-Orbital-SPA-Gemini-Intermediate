import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:orbital_spa/services/auth/models/auth_user.dart';

/// Parent class of all types of authentication states.
@immutable
abstract class AuthState {

  /// [isLoading] is used to determine if the loading screen is active.
  final bool isLoading;
  final String? loadingText;

  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment'
  });
}

/// State when user has not been initialised.
class AuthStateUninitialised extends AuthState {
  const AuthStateUninitialised({required isLoading})
      : super(isLoading: isLoading);
}

/// State when user is registering.
/// 
/// Can handle event where user has failed to register.
class AuthStateRegistering extends AuthState {
  // Exceptions that may be thrown when user is registering.
  final Exception? exception;

  const AuthStateRegistering({
    required this.exception,
    required isLoading
  }) : super(isLoading: isLoading);
}

/// State when user has not verified email and has already registered.
class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({
    required isLoading
  }) : super(isLoading: isLoading);
}

/// State when user forgot their password.
/// 
/// Can have different events happening with this state.
/// [exception]: null, [hasSentEmail]: false => user has just opened the forgot password page.
/// [exception]: null, [hasSentEmail]: true => link has been successfully sent.
/// [exception]: !null, [hasSentEmail]: false => link failed to send.
class AuthStateForgotPassword extends AuthState {
  // Exceptions that may be thrown if the password reset link cannot be sent.
  final Exception? exception;
  // Tracks if the reset link has been sent.
  final bool hasSentEmail;

  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSentEmail,
    required isLoading
  }) : super(isLoading: isLoading);
}

/// State when user is already logged in.
class AuthStateLoggedIn extends AuthState {
  final AuthUser user;

  const AuthStateLoggedIn({
    required this.user,
    required isLoading
  }) : super(isLoading: isLoading);
}



/// State when user is logged out. 
/// 
/// Can have different events happening with this state.
/// [exception]: null, [isLoading]: false => Regular logged out state.
/// [exception]: null, [isLoading]: true => User's log in is being processed currently.
/// [exception]: !null, [isLoading]: true => User has failed to log in or log out and an exception was thrown.
class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;

  const AuthStateLoggedOut({
    required this.exception,
    required isLoading,
    String? loadingText
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText
        );

  // Used to compare AuthStateLoggedOut instances.
  @override
  List<Object?> get props => [exception, isLoading];
}