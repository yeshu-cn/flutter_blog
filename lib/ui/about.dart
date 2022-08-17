import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              child: RichText(text: TextSpan(children: [WidgetSpan(child: codeWidget()), TextSpan(text: '解析Json的时候也不能直观的从Class类文件结构看出Json格式生成代码不依赖第三方，不对代码造成任何影响。但是生成的代码块都在一个文件中，都是些结构类似的模版代码，而且如果字段和json key不一致的话，需要手动去修改代码。解析Json的时候也不能直观的从Class类文件结构看出Json格式。'), TextSpan(text: '123'), WidgetSpan(child: codeWidget())])),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 500, right: 500, top: 40),
              child: FutureBuilder(
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    return Markdown(
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

Widget codeWidget() {
  return Container(
    padding:
        EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
    decoration:
        BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Colors.green,
        ),
    child: SelectableText(
      'node.textContent',
    ),
  );
}