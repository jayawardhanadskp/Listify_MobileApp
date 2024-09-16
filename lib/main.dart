import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:listify_nodeapi_mongodb/screens/dashboard_screen.dart';
import 'package:listify_nodeapi_mongodb/screens/login_screen.dart';
import 'package:listify_nodeapi_mongodb/screens/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(token: prefs.getString('token')!));
}

class MyApp extends StatelessWidget {
  final String token; 

  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: (token != null && !JwtDecoder.isExpired(token!)) 
          ? DashboardScreen(token: token) 
          : LoginScreen(), // Assuming you want to redirect to LoginScreen if expired or token is null
    );
  }
}
