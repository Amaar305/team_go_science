import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../utils/constants.dart';
import '../widgets/create_widgets/create_form.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? emailEditingController;
  TextEditingController? passwordEditingController;
  TextEditingController? nameEditingController;

  @override
  void initState() {
    super.initState();

    emailEditingController = TextEditingController();
    nameEditingController = TextEditingController();
    passwordEditingController = TextEditingController();
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      AuthController.instance.register(
        emailEditingController!.text.trim(),
        passwordEditingController!.text.trim(),
        nameEditingController!.text.trim(),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailEditingController!.clear();
    passwordEditingController!.clear();
    nameEditingController!.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(signup),
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
                      hintText: 'Name',
                      controller: nameEditingController!,
                    ),
                    MyTextField(
                      hintText: 'Password',
                      controller: passwordEditingController!,
                      obscure: true,
                      maxLines: 1,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(LoginScreen.routeName);
                      },
                      child: const Text(
                        'Already registerred? login',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _trySubmit();
                      },
                      child: const Text(
                        signup,
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
