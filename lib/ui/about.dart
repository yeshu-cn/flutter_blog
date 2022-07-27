import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/top_bar.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            TopBar(),
            Text('about'),
          ],
        ),
      ),
    );
  }
}
