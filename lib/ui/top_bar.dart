import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/about.dart';
import 'package:flutter_blog/ui/categories.dart';
import 'package:flutter_blog/ui/home.dart';
import 'package:flutter_blog/ui/utils/utils.dart';

class TopBar extends StatefulWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(color: Color(0xffF5F5F5)),
          height: 80,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  navigateTo(context, const Home());
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Home'),
                ),
              ),
              InkWell(
                onTap: () {
                  navigateTo(context, const Categories());
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Categories'),
                ),
              ),
              InkWell(
                onTap: () {
                  navigateTo(context, const About());
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('About'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
