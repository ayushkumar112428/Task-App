import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        // colorScheme: ColorScheme.fromSeed(primary: Colors.black,seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const TaskHomeScreen(),
    );
  }
}