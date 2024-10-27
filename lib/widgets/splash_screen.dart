import 'dart:async';
import 'package:expense_tracker2/widgets/expenses.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Expenses(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: const Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "A H T",
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'myfonts2',
                  color: Color.fromARGB(255, 165, 125, 2),
                ),
              ),
              LinearProgressIndicator(),
            ],
          ))),
    );
  }
}
