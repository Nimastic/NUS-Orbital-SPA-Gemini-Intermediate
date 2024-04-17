import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orbital_spa/constants/images_strings.dart';
import 'package:orbital_spa/services/auth/bloc/auth_bloc.dart';
import 'package:orbital_spa/services/auth/bloc/auth_events.dart';
import 'package:orbital_spa/services/auth/bloc/auth_state.dart';
import 'package:orbital_spa/utilities/dialogs/error_dialog.dart';
import 'package:orbital_spa/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {

  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          } else if (state.exception != null) {
            await showErrorDialog(context, 
            'Request could not be processsed. Please make sure you are a registered user.');
          }
        }
      },

      child: Scaffold(
        appBar: AppBar(
          // title: const Text('Forgot Password'),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage(forgotPasswordPageImage),
                  height: size.height * 0.2,
                ),
        
                const Text(
                  'Resetting your password is as easy as ABC!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'GT Walsheim'
                  ),
                ),
        
                const SizedBox(height: 10.0),
        
                const Text(
                  'Enter the email associated with your account to receive instructions on how to reset your password',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'GT Walsheim'
                  )
                ),

                const SizedBox(height: 20),
                
                // Email Textfield.
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email here',
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.mail_outline_outlined),
                    border: OutlineInputBorder()
                  ),
                ),

                const SizedBox(height: 10),
                
                // Submit email button.
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final email = _controller.text;
                      context.read<AuthBloc>().add(AuthEventForgotPassword(email: email));
                    },
                    child: const Text('CONFIRM')
                  ),
                ),
                
                // Back to login page button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(const AuthEventLogOut());
                    },
                    child: const Text('Back to login page')
                  ),
                )
              ],
            ),
          ),
        )
      )
    );
  }
}