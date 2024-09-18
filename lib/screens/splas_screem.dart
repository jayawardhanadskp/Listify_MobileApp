import 'package:flutter/material.dart';
import 'package:listify_nodeapi_mongodb/utils/app_colors.dart';

class SplasScreen extends StatelessWidget {
  const SplasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/logo.png',
            scale: 5,
          ),
        ),
      ),
    );
  }
}
