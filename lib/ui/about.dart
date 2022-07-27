import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/top_bar.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TopBar(
              highLightAbout: true,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 500, right: 500, top: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 500, right: 500, top: 40),
              child: Row(
                children: [
                  Text(
                    '兴趣：听歌写代码，爱好足球，滑雪',
                    style: theme.textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 500, right: 500, top: 10),
              child: Row(
                children: [
                  Text(
                    '邮箱：guan.yeshu@gmail.com',
                    style: theme.textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
