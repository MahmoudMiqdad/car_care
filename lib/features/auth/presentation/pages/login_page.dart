import 'package:car_care/features/auth/presentation/pages/register_page.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_content.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_header.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement login logic
    }
  }

  void _onForgotPassword() {}

  void _onRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const RegisterPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/BK_.png',
              fit: BoxFit.cover,
            ),
            SafeArea(
              child: Column(
                children: [
                  const LoginHeader(),
                  Expanded(
                    child: LoginContent(
                      formKey: _formKey,
                      accountController: _accountController,
                      passwordController: _passwordController,
                      onLogin: _onLogin,
                      onForgotPassword: _onForgotPassword,
                      onRegister: _onRegister,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
