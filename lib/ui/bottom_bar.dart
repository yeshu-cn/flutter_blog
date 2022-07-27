import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: const Color(0xffF5F5F5),
      width: MediaQuery.of(context).size.width,
      child: const Text('@ 2022 yeshu'),
    );
  }
}
