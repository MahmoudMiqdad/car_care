import 'package:car_care/features/auth/presentation/widgets/login/login_header.dart';
import 'package:car_care/features/auth/presentation/widgets/register/register_content.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _accountController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
  }

  void _onGoToLogin() {
    Navigator.of(context).maybePop();
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
                    child: RegisterContent(
                      formKey: _formKey,
                      firstNameController: _firstNameController,
                      accountController: _accountController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      onRegister: _onRegister,
                      onGoToLogin: _onGoToLogin,
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
