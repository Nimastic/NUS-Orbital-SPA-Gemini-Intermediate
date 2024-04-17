import 'package:flutter/material.dart';

/// Parent class for all authenication events.
@immutable 
abstract class AuthEvent {
  const AuthEvent();
}

/// Event where user is being initialised.
class AuthEventInitialise extends AuthEvent {
  const AuthEventInitialise();
}

/// Event where user is registering
class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;

  const AuthEventRegister(this.email, this.password);
}

/// Event where user is routed to the register page
class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

/// Event where verification email is sent
class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

// Event where user forgot password
class AuthEventForgotPassword extends AuthEvent {
  final String? email;

  const AuthEventForgotPassword({this.email});
}

/// Event where user is logging in.
class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;

  const AuthEventLogIn(this.email, this.password);
}

/// Event where user is logging out.
class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}

/// Event where user is logging in with Google.
class AuthEventGoogleLogIn extends AuthEvent {
  const AuthEventGoogleLogIn();
}


