// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchantside_app/features/auth/providers/auth_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MerchantLoginScreen extends ConsumerStatefulWidget {
  const MerchantLoginScreen({super.key});

  @override
  ConsumerState<MerchantLoginScreen> createState() =>
      _MerchantLoginScreenState();
}

class _MerchantLoginScreenState extends ConsumerState<MerchantLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isChecked = false;

  bool get isEmailValid => emailController.text.contains('@');
  bool get isPasswordValid => passwordController.text.isNotEmpty;
  bool get isEnabled => isEmailValid && isPasswordValid && _isChecked;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final size = MediaQuery.of(context).size;

    ref.listen<AuthState>(authProvider, (previous, next) async {
      if (next.status == AuthStatus.success && next.token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwtToken', next.token!);
        await prefs.setBool('isMerchantLoggedIn', true);

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/merchantHome',
          (route) => false,
        );

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Login Successful ✅")));
      } else if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message ?? "Something went wrong")),
        );
      }
    });

    final Color buttonColor = isEnabled ? const Color(0xFF571094) : Colors.grey;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height - 40),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  Image.asset(
                    'assets/Logo.png',
                    width: size.width * 0.4,
                    height: size.width * 0.4,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Sign In With Email",
                    style: TextStyle(
                      color: Color(0xFF571094),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please Enter Your Email & Password",
                    style: TextStyle(color: Color(0xFF737373)),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "admin@system.com",
                      labelText: "Email",
                      border: const OutlineInputBorder(),
                      errorText: emailController.text.isEmpty
                          ? null
                          : (!isEmailValid ? "Enter valid email" : null),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter password",
                      labelText: "Password",
                      border: const OutlineInputBorder(),
                      errorText: passwordController.text.isEmpty
                          ? null
                          : (!isPasswordValid ? "Enter password" : null),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        activeColor: const Color(0xFF571094),
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          "I agree to the Terms & Conditions",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          (!isEnabled || authState.status == AuthStatus.loading)
                          ? null
                          : () {
                              ref
                                  .read(authProvider.notifier)
                                  .login(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: authState.status == AuthStatus.loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
