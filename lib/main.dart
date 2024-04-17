import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:orbital_spa/helpers/loading/loading_screen.dart';
import 'package:orbital_spa/provider/chats_provider.dart';
import 'package:orbital_spa/provider/models_provider.dart';
import 'package:orbital_spa/services/auth/bloc/auth_bloc.dart';
import 'package:orbital_spa/services/auth/bloc/auth_events.dart';
import 'package:orbital_spa/services/auth/bloc/auth_state.dart';
import 'package:orbital_spa/services/auth/data/providers/firebase_auth_provider.dart';
import 'package:orbital_spa/services/model/ml_model.dart';
import 'package:orbital_spa/services/notifications/notifications_service.dart';
import 'package:orbital_spa/views/authentication/login_view.dart';
import 'package:orbital_spa/views/main_page.dart';
import 'package:orbital_spa/views/authentication/register_view.dart';
import 'package:orbital_spa/views/authentication/verify_email.dart';
import 'package:provider/provider.dart';

import 'constants/theme.dart';
import 'views/authentication/forgot_password_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotifyHelper notifyHelper = NotifyHelper();

  await notifyHelper.initializeNotification();
  notifyHelper.requestIOSPermissions();
  await MlModel().initializeModel();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => ModelsProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ChatProvider(),
      ),
    ],
    child: GetMaterialApp(
        theme: Themes.light,
        home: BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
          child: const HomePage(),
        ),
      ),
    )
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    context.read<AuthBloc>().add(const AuthEventInitialise());

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context, 
            text: state.loadingText ?? 'Please wait a moment'
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        // Toggle to different views based on the current state.
        if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateLoggedIn) {
          return const MainPage();
        } else {
          return const Scaffold(body: CircularProgressIndicator());
        }
      },
    );
  }
}