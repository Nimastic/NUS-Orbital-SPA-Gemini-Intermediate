import 'package:bloc/bloc.dart';
import 'package:orbital_spa/services/auth/bloc/auth_events.dart';
import 'package:orbital_spa/services/auth/bloc/auth_state.dart';
import '../data/providers/auth_provider.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialised(isLoading: true)) {

    /// Actions taken to initialise provider.
    /// 
    /// After initialising, check if user is empty.
    /// If there is no current user, emit regular [AuthStateLoggedOut].
    /// If there is a user and email isn't verified, emit [AuthStateNeedsVerification].
    /// Else, user has successfully logged in and emit [AuthStateLoggedIn]
    on<AuthEventInitialise>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;

      if (user == null) {
        emit(
          const AuthStateLoggedOut(
            exception: null, 
            isLoading: false
          )
        );
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });

    on<AuthEventShouldRegister>((event, emit) async {
      emit(const AuthStateRegistering(exception: null, isLoading: false));
    },);


    /// Actions taken when user registers.
    /// 
    /// Calls to AuthProvider Class to create user and if successful, send verification.
    /// Successful creation: State emitted changes to [AuthStateNeedsVerification].
    /// Unsuccessful creation: State emitted changes to [AuthStateRegistering].
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        // Create a user using the given email and password.
        await provider.createUser(
          email: email, 
          password: password
        );
        // Send email verification upon successful creation.
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isLoading: false));
      }
    });



    /// Actions taken in the event of sending email verification.
    /// 
    /// Calls to AuthProvider class to send the email. 
    /// State emitted remains unchanged. 
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    /// Actions taken if user forgot password.
    /// 
    /// First emit [AuthStateForgotPassword] without exceptions or calls to provider.
    /// 
    on<AuthEventForgotPassword>((event, emit) async {
      emit(
        const AuthStateForgotPassword(
          exception: null, 
          hasSentEmail: false, 
          isLoading: false
        )
      );

      final email = event.email;
      if (email == null) {
        return;
      }

      //user actually wants to send a forgot pw email
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: true
      ));

      bool didSendEmail;
      Exception? exception;
      try {
        await provider.sendPasswordReset(toEmail: email);
        didSendEmail= true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }

      emit(AuthStateForgotPassword(
        exception: exception,
        hasSentEmail: didSendEmail,
        isLoading: false
      ));
    });

    /// Actions taken when a user tries to log in.
    ///
    /// Brings up the loading screen while user is being logged in.
    /// Login Failure: emits [AuthStateLoggedOut] that contains the exception thrown.
    /// Successful Login: either emits [AuthStateNeedsVerification] or [AuthStateLoggedIn].
    on<AuthEventLogIn>((event, emit) async {
      
      // Calls the loading screen.
      emit(
        const AuthStateLoggedOut(
          exception: null, 
          isLoading: true,
          loadingText: 'Please wait to be logged in. This may take a few seconds'
        )
      );

      final email = event.email;
      final password = event.password;

      try {
        // Call to provider to log in user.
        final user = await provider.logIn(
          email: email, 
          password: password
        );

        // On successful login, check if user is verified.
        if (!user.isEmailVerified) {
          emit(
            // Removes loading screen.
            const AuthStateLoggedOut(
              exception: null, 
              isLoading: false
            )
          );
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          // Removes loading screen.
          emit(const AuthStateLoggedOut(
            exception: null, 
            isLoading: false
            )
          );
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }

      } on Exception catch (e) {
        // Login has failed and an exception was thrown.
        emit(
          AuthStateLoggedOut(
            exception: e, 
            isLoading: false
          )
        );
      }
    });

    /// Actions taken when a user tries to log out.
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();

        // Successful logout: emit regular [AuthStateLoggedOut].
        emit(const AuthStateLoggedOut(
          exception: null, 
          isLoading: false
          )
        );
      } on Exception catch (e) {
        // Unsuccessful logout: emit [AuthStateLoggedOut] with caught exception.
        emit(AuthStateLoggedOut(
          exception: e, 
          isLoading: false
          )
        );
      }
    });


    on<AuthEventGoogleLogIn>((event, emit) async {
      // Calls the loading screen.
      emit(
        const AuthStateLoggedOut(
          exception: null, 
          isLoading: true,
          loadingText: 'Please wait to be logged in. This may take a few seconds'
        )
      );

      try {
        final user = await provider.logInWithGoogle();

        // Removes loading screen.
        emit(const AuthStateLoggedOut(
          exception: null, 
          isLoading: false
          )
        );

        emit(AuthStateLoggedIn(user: user, isLoading: false));
      } on Exception catch (e) {
        // Login has failed and an exception was thrown.
        emit(
          AuthStateLoggedOut(
            exception: e, 
            isLoading: false
          )
        );
      }
    });

  }
}