// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchantside_app/core/storage/secure_storage_service.dart';

import 'package:merchantside_app/features/auth/providers/merchant_signup_provider.dart';

class MerchantSignupScreen extends ConsumerStatefulWidget {
  const MerchantSignupScreen({super.key});

  @override
  ConsumerState<MerchantSignupScreen> createState() =>
      _MerchantSignupScreenState();
}

class _MerchantSignupScreenState extends ConsumerState<MerchantSignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _holderNameController = TextEditingController();

  bool _isChecked = false;

  bool get isEmailValid => _emailController.text.contains('@');
  bool get isPasswordValid => _passwordController.text.isNotEmpty;
  bool get isShopNameValid => _shopNameController.text.isNotEmpty;
  bool get isCategoryValid => _categoryController.text.isNotEmpty;
  bool get isEnabled =>
      isEmailValid &&
      isPasswordValid &&
      isShopNameValid &&
      isCategoryValid &&
      _isChecked;

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupProvider);
    final size = MediaQuery.of(context).size;

    // Listen to signup state changes
    ref.listen<SignupState>(signupProvider, (prev, next) async {
      if (next.status == SignupStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message ?? "Signup Successful ✅"),
            backgroundColor: Colors.green,
          ),
        );

        if (next.token != null) {
          // Token exists → go to home
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/merchanthome',
            (route) => false,
          );
        } else {
          // No token → navigate to login for user to log in
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/merchantlogin',
            (route) => false,
          );
        }
      } else if (next.status == SignupStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message ?? "Signup failed"),
            backgroundColor: Colors.red,
          ),
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
                    "Create Your Merchant Account",
                    style: TextStyle(
                      color: Color(0xFF571094),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please fill in your details to sign up",
                    style: TextStyle(color: Color(0xFF737373)),
                  ),
                  const SizedBox(height: 30),

                  // Email
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "shop@test.com",
                      border: const OutlineInputBorder(),
                      errorText: _emailController.text.isEmpty
                          ? null
                          : (!isEmailValid ? "Enter a valid email" : null),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter password",
                      border: const OutlineInputBorder(),
                      errorText: _passwordController.text.isEmpty
                          ? null
                          : (!isPasswordValid ? "Enter password" : null),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Shop Name
                  TextField(
                    controller: _shopNameController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: "Shop Name",
                      hintText: "Your Shop Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Category
                  TextField(
                    controller: _categoryController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: "Category",
                      hintText: "e.g. General, Electronics",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Bank Details Section
                  const Text(
                    "Bank Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: _bankNameController,
                    decoration: const InputDecoration(
                      labelText: "Bank Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: _accountNumberController,
                    decoration: const InputDecoration(
                      labelText: "Account Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: _ifscCodeController,
                    decoration: const InputDecoration(
                      labelText: "IFSC Code",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: _holderNameController,
                    decoration: const InputDecoration(
                      labelText: "Account Holder Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        activeColor: const Color(0xFF571094),
                        onChanged: (v) => setState(() {
                          _isChecked = v ?? false;
                        }),
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

                  // Sign Up button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          (!isEnabled ||
                              signupState.status == SignupStatus.loading)
                          ? null
                          : () {
                              ref
                                  .read(signupProvider.notifier)
                                  .signup(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                    shopName: _shopNameController.text.trim(),
                                    category: _categoryController.text.trim(),
                                    bankName: _bankNameController.text.trim(),
                                    accountNumber: _accountNumberController.text
                                        .trim(),
                                    ifscCode: _ifscCodeController.text.trim(),
                                    holderName: _holderNameController.text
                                        .trim(),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: signupState.status == SignupStatus.loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Already have an account? Login
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/merchantlogin');
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          color: Color(0xFF737373),
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                              color: Color(0xFF571094),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Spacer(flex: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
