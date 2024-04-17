import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orbital_spa/constants/images_strings.dart';
import 'package:orbital_spa/services/auth/bloc/auth_events.dart';
import '../../services/auth/auth_exceptions.dart';
import '../../services/auth/bloc/auth_bloc.dart';
import '../../services/auth/bloc/auth_state.dart';
import '../../utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email already in use');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid Email');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed to register');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // title: const Text('Create A New Account'),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      image: const AssetImage(registerPageImage),
                      height: size.height * 0.2
                    ),
                    
                    const Text(
                      "Get on Board!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GT Walsheim'
                      ),
                      textAlign: TextAlign.start,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Create your profile here to start enjoying SPA',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'GT Walsheim'
                      )
                    ),
                  ],
                ),
                  
                Form(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email textfield.
                        TextFormField(
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

                        // Password textfield
                        TextFormField(
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

                        // Submit button.
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              final email = _email.text;
                              final password = _password.text;
                                
                              // Add login event.
                              context.read<AuthBloc>().add(AuthEventRegister(email, password));
                            },
                            child: const Text('SUBMIT')
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Login button.
                    TextButton(
                      onPressed: () {
                        // Routes users to login page.
                        context.read<AuthBloc>().add(const AuthEventLogOut());
                      },
                      child: Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: const [
                            TextSpan(
                              text: 'Log in here!',
                              style: TextStyle(color: Colors.blue)
                            ) 
                          ]
                        )
                      )
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}
