import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../utils/constants.dart';
import '../widgets/create_widgets/create_form.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  final _formKey = GlobalKey<FormState>();
  TextEditingController? emailEditingController;
  TextEditingController? passwordEditingController;

  @override
  void initState() {
    super.initState();

    emailEditingController = TextEditingController();
    passwordEditingController = TextEditingController();
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      AuthController.instance.login(emailEditingController!.text.trim(),
          passwordEditingController!.text.trim());
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailEditingController!.clear();
    passwordEditingController!.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(login),
        centerTitle: true,
      ),
      body: Padding(
        padding: kDefaultAppPadding,
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyTextField(
                      hintText: 'Email',
                      controller: emailEditingController!,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    MyTextField(
                      hintText: 'Password',
                      controller: passwordEditingController!,
                      obscure: true,
                      maxLines: 1,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(SignUpScreen.routeName);
                      },
                      child: const Text(
                        'Don\'t have an account? register',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _trySubmit();
                      },
                      child: const Text(
                        login,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
