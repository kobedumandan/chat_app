import 'package:chat_app/components/my_button_register.dart';
import 'package:chat_app/services/auth/auth_services.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  // email and pass controllers
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  // CHANGE PAGES
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  // register function
  void register(BuildContext context) {
    final _auth = AuthService();

    // if passwords match, register user
    if (_confirmController.text == _passController.text) {
      try {
        _auth.signUpWithEmailPassword(
          context,
          _emailController.text.trim(),
          _passController.text.trim(),
          _fnameController.text.trim(),
          _lnameController.text.trim(),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(title: Text(e.toString())),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text("Passwords don't match!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.message,
                size: 60,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.greenAccent
                    : Colors.grey.shade800,
              ),
          
              const SizedBox(height: 40),
          
              Text(
                "Let's create an account for you!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
          
              const SizedBox(height: 25),
          
              MyTextField(
                hintText: 'First Name',
                obscureText: false,
                controller: _fnameController,
              ),
          
              const SizedBox(height: 12),
          
              MyTextField(
                hintText: 'Last Name',
                obscureText: false,
                controller: _lnameController,
              ),
          
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Divider(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 10),
          
              MyTextField(
                hintText: 'Email',
                obscureText: false,
                controller: _emailController,
              ),
          
              const SizedBox(height: 12),
          
              MyTextField(
                hintText: 'Password',
                obscureText: true,
                controller: _passController,
              ),
          
              const SizedBox(height: 12),
          
              MyTextField(
                hintText: 'Confirm password',
                obscureText: true,
                controller: _confirmController,
              ),
          
              const SizedBox(height: 20),
          
              MyButtonRegister(
                text: 'Register',
                onTap: () => register(context),
                color: Colors.green,
              ),
          
              const SizedBox(height: 25),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "Login now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
