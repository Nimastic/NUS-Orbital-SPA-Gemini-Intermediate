import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orbital_spa/constants/images_strings.dart';
import 'package:orbital_spa/services/auth/auth_exceptions.dart';
import 'package:orbital_spa/services/auth/bloc/auth_events.dart';
import '../../services/auth/bloc/auth_bloc.dart';
import '../../services/auth/bloc/auth_state.dart';
import '../../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;


  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User not found',);
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication Error');
          }
        }
      },
      child: Scaffold(
          appBar: AppBar(
            // title: const Text('Login'),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header widget.
                  Image(image: const AssetImage(loginPageImage), height: size.height * 0.2),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'GT Walsheim'
                    )
                    
                  ),
                  
                  const SizedBox(height: 10),

                    const Text(
                      'Enter your credentials to continue your time in SPA',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'GT Walsheim'
                      )
                    ),
                  
                  // Center form widget.
                  Form(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Email textfield.
                          TextFormField(
                            key: const Key('Log In Email'),
                            controller: _email,
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.person_outline_outlined),
                              border: OutlineInputBorder()
                            ),
                          ),

                          const SizedBox(height: 10.0),

                          // Password textfield.
                          TextFormField(
                            key: const Key('Log In Password'),
                            controller: _password,
                            enableSuggestions: false,
                            autocorrect: false,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.fingerprint),
                              border: OutlineInputBorder()
                            ),
                          ),

                          const SizedBox(height: 10.0),

                          // Forgot password button.
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              key: const Key('Forgot Password Button'),
                              onPressed: () {
                                // Routes users to forgot password page
                                context.read<AuthBloc>().add(const AuthEventForgotPassword());
                              },
                              child: const Text('Forgot password?')
                            ),
                          ),

                          // Login button.
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              key: const Key("Log In"),
                              onPressed: () async {
                                final email = _email.text;
                                final password = _password.text;
                                
                                // Add login event.
                                context
                                    .read<AuthBloc>()
                                    .add(AuthEventLogIn(email, password));
                              },
                              child: const Text('LOGIN')
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Footer Widget
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('OR'),
                      const SizedBox(height: 10),

                      // Google log in button.
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Image (
                            image: AssetImage(googleLogoImage),
                            width: 20.0
                          ),
                          onPressed: () {
                            context.read<AuthBloc>().add(const AuthEventGoogleLogIn());
                          },
                          label: const Text('Sign in with Google')
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Register button.
                      TextButton(
                        onPressed: () {
                          // Routes users to register page.
                          context.read<AuthBloc>().add(const AuthEventShouldRegister());
                        },
                        child: Text.rich(
                          TextSpan(
                            text: "Don't have an Account? ",
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: const [
                              TextSpan(
                                text: 'Sign up here!',
                                style: TextStyle(color: Colors.blue)
                              ) 
                            ]
                          )
                        )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
