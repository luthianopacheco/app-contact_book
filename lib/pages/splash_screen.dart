import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final colorizeTextStyle = const TextStyle(fontFamily: 'Agne', fontSize: 40);
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    delayedImageFunction();
    nextPage();
  }

  delayedImageFunction() {
    Future.delayed(
        const Duration(seconds: 1),
        () => setState(() {
              _visible = true;
            }));
  }

  nextPage() {
    Future.delayed(const Duration(seconds: 2), () => Get.toNamed('/home'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 1, 211, 120),
              Color.fromARGB(255, 0, 137, 201),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: const Duration(seconds: 1),
            child: const Image(
                image: AssetImage('assets/images/icon.png'), height: 150),
          ),
        ),
      ),
    );
  }
}
