import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var isObsecure = true.obs;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF371733),
      
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset('assets/logo.png')),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(10),
                    //   color: Colors.pink[10],
                    //   boxShadow: const [
                    //     BoxShadow(
                    //       blurRadius: 8,
                    //       color: Colors.black26,
                    //       offset: Offset(0, -3),
                    //     ),
                    //   ],
                    // ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                         
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                _buildEmailField(),
                                const SizedBox(height: 20),
                                _buildPasswordField(),
                                const SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: () {}, 
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.yellow,
                                    foregroundColor: AppColors.white,
                                    fixedSize: const Size(200, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'SIGN IN',
                                    style: AppFonts.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don\'t have an Account?',
                                  style: AppFonts.bodyText1white,
                                ),
                                const SizedBox(width: 0),
                                TextButton(
                                  onPressed: () {
                                    Get.to(() => const SignupScreen());
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: AppFonts.bodyText1pink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      validator: (value) => value == '' ? 'Please Enter Email' : null,
      decoration: _inputDecoration(
        hintText: 'Email',
        icon: Icons.email,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Obx(() => TextFormField(
      controller: _passwordController,
      obscureText: isObsecure.value,
      validator: (value) => value == '' ? 'Please Enter Password' : null,
      decoration: _inputDecoration(
        hintText: 'Password',
        icon: Icons.lock,
        suffixIcon: GestureDetector(
          onTap: () => isObsecure.value = !isObsecure.value,
          child: Icon(
            isObsecure.value ? Icons.visibility_off : Icons.visibility,
            color: Colors.yellow[400],
          ),
        ),
      ),
    ));
  }

  InputDecoration _inputDecoration(
      {required String hintText, required IconData icon, Widget? suffixIcon}) {
    return InputDecoration(
      prefixIcon: Icon(
        icon,
        color: AppColors.yellow,
      ),
      suffixIcon: suffixIcon,
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.yellow[500]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.yellow),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.yellow),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.yellow),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.yellow),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      fillColor: Colors.white,
      filled: true,
    );
  }
}
