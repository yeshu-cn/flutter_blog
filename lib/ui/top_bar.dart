import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/about.dart';
import 'package:flutter_blog/ui/categories.dart';
import 'package:flutter_blog/ui/home.dart';
import 'package:flutter_blog/ui/utils/utils.dart';

class TopBar extends StatefulWidget {
  final bool highLightHome;
  final bool highLightCategory;
  final bool highLightAbout;

  const TopBar(
      {Key? key,
      this.highLightAbout = false,
      this.highLightCategory = false,
      this.highLightHome = false})
      : super(key: key);

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
                child: _buildItem(
                    'Home', Icons.home_rounded, widget.highLightHome),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  navigateTo(context, const Categories());
                },
                child: _buildItem('Categories', Icons.category_rounded,
                    widget.highLightCategory),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  navigateTo(context, const About());
                },
                child: _buildItem(
                    'About', Icons.person_rounded, widget.highLightAbout),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItem(String name, IconData iconData, bool highLight) {
    var theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          color: highLight ? Colors.grey[300] : Colors.transparent,
          borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
        child: Row(
          children: [
            Icon(
              iconData,
              size: 14,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              name,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
