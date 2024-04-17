import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:orbital_spa/firebase_options.dart';
import 'package:orbital_spa/services/auth/models/auth_user.dart';
import 'package:orbital_spa/services/auth/data/providers/auth_provider.dart';
import 'package:orbital_spa/services/auth/auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null){
      user.reload();
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, 
        password: password
      );

      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password'){
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    if (user != null) {
      await FirebaseAuth.instance.signOut();
      await googleSignIn.disconnect();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotFoundAuthException();
    }
  }
  
  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'firebase_auth/invalid-email':
          throw InvalidEmailAuthException();
        case 'firebase_auth/user-not-found':
          throw UserNotFoundAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
  
  @override
  Future<AuthUser> logInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
         await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken
      );

      try {
        await FirebaseAuth.instance.signInWithCredential(credential);

        final user = currentUser;
        if (user != null) {
          return user;
        }

      } on FirebaseAuthException catch(e) {
        if (e.code == 'account-exists-with-different-credential') {
          throw AccountExistsWithDifferentCrendentialsGoogleException();
        } else if (e.code == 'invalid-credential') {
          throw InvalidCrendentialGoogleException();
        } else if (e.code == 'operation-not-allowed') {
          throw OperationNotAllowedGoogleException();
        } else if (e.code == 'user-disabled') {
          throw UserDisabledGoogleException();
        } else if (e.code == 'user-not-found') {
          throw UserNotFoundGoogleException();
        } else if (e.code == 'wrong-password') {
          throw WrongPasswordGoogleException();
        } else if (e.code == 'invalid-verification-code') {
          throw InvalidVerificationCodeGoogleException();
        } else if (e.code == 'invalid-verification-id') {
          throw InvalidVerificationIDGoogleException();
        } else {
          throw GenericGoogleException();
        }
      } catch (_) {
        throw GenericGoogleException();
      }
    }
    throw UserNotLoggedInAuthException();
  }

}