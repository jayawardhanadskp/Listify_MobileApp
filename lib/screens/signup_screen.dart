// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:listify_nodeapi_mongodb/services/config.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var isObsecure = true.obs;

  bool _isNotValid = false;

  void registerUser() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      var regBody = {
        "email": _emailController.text,
        "password": _passwordController.text,
      };

      var response = await http.post(Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonresponse = jsonDecode(response.body);
      print(jsonresponse['status']);

      if (jsonresponse['status'] == true) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Sucessfully Registerd')));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        print('erro signin');
      }
    } else {
      setState(() {
        _isNotValid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF371733),
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
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset('assets/logo.png')),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              _buildNameField(),
                              const SizedBox(height: 20,),
                              _buildEmailField(),
                              const SizedBox(height: 20),
                              _buildPasswordField(),
                              const SizedBox(height: 40),
                              ElevatedButton(
                                  onPressed: () {
                                    registerUser();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.yellow,
                                      foregroundColor: AppColors.white,
                                      fixedSize: const Size(200, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      )),
                                  child: Text(
                                    'SIGN UP',
                                    style: AppFonts.normal,
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Have an Account?',
                                style: AppFonts.bodyText1white,
                              ),
                              const SizedBox(
                                width: 0,
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(const LoginScreen());
                                },
                                child: Text(
                                  'Sign In',
                                  style: AppFonts.bodyText1pink,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
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

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      validator: (value) => value == '' ? 'Please Enter Name' : null,
      decoration: _inputDecoration(
        hintText: 'Name',
        icon: Icons.person,
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
      errorStyle: const TextStyle(color: Colors.red),
      errorText: _isNotValid ? 'Enter Propper InFo' : null,
    );
  }
}
