import 'package:orbital_spa/services/auth/auth_exceptions.dart';
import 'package:orbital_spa/services/auth/data/providers/auth_provider.dart';
import 'package:orbital_spa/services/auth/models/auth_user.dart';

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {

  var _isInitialized = false;
  AuthUser? _user;

  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({required String email, required String password}) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email, 
      password: password
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(
      isEmailVerified: false, 
      email: 'foo@bar.com', 
      id: 'my_id',
      userName: 'foobar'
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(
      isEmailVerified: true, 
      email: 'foo@bar.com',
      id: 'my_id', 
      userName: 'foobar'
    );
    _user = newUser;
  }
  
  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    throw UnimplementedError();
  }
  
  @override
  Future<AuthUser> logInWithGoogle() {
    throw UnimplementedError();
  }

}