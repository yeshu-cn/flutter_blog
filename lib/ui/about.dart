import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blog/ui/top_bar.dart';
import 'package:markdown_widget/markdown_widget.dart';

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
              child: FutureBuilder(
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    return MarkdownWidget(
                      styleConfig: StyleConfig(

                      ),
                      data: snapshot.data!,
                      shrinkWrap: true,
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                future: _loadAboutMarkdown(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _loadAboutMarkdown() async {
    return await rootBundle.loadString('assets/pages/test.md');
  }
}
