import 'package:orbital_spa/services/auth/data/providers/auth_provider.dart';
import 'package:orbital_spa/services/auth/models/auth_user.dart';
import 'package:orbital_spa/services/auth/data/providers/firebase_auth_provider.dart';

/// The AuthenticationRepository is responsible for abstracting the underlying implementation 
/// of how a user is authenticated, as well as how a user is fetched.

class AuthRepository implements AuthProvider {
final AuthProvider provider;
const AuthRepository(this.provider);

factory AuthRepository.firebase() => AuthRepository(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email, 
    required String password
  }) => provider.createUser(
    email: email,
    password: password
  );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<AuthUser> logIn({
    required String email, 
    required String password
  }) => provider.logIn(
    email: email,
    password: password
  );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
  
  @override
  Future<void> sendPasswordReset({required String toEmail}) => provider.sendPasswordReset(toEmail: toEmail);

  @override
  Future<AuthUser> logInWithGoogle() => provider.logInWithGoogle();

}