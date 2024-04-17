import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orbital_spa/constants/images_strings.dart';
import 'package:orbital_spa/services/auth/bloc/auth_bloc.dart';
import 'package:orbital_spa/services/auth/bloc/auth_events.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        // title: const Text('Email Verification'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage(verifyEmailPageImage),
              height: size.height * 0.2
            ),

            const SizedBox(height: 20,),

            const Text(
              'Please verify your email',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'GT Walsheim'
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Your're almost there! We've just sent an email to you. Simply click on the link to complete your signup.",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'GT Walsheim'
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 50),

            const Text(
              "Still can't find the email?",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'GT Walsheim'
              )
            ),

            const SizedBox(height: 20),
      
            // Send email verification button.
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(const AuthEventSendEmailVerification());
                },
                child: const Text('Resend Email')
              ),
            ),
      
            // Go back to login page button
            TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(const AuthEventLogOut()); 
              }, 
              child: Text.rich(
                TextSpan(
                  text: "Ready to log in? ",
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: const [
                    TextSpan(
                      text: 'Click here!',
                      style: TextStyle(color: Colors.blue)
                    ) 
                  ]
                )
              )
            )
          ],
        ),
      )
    );
  }
}