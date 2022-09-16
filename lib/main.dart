import 'package:flutter/material.dart';
import 'package:flutter_blog/di/di.dart';
import 'package:flutter_blog/ui/home.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setupDi();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.sourceCodeProTextTheme(Theme.of(context).textTheme)
      ),
      home: const SelectionArea(
        child: Home(),
      ),
    );
  }
}