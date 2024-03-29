import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/di/di.dart';
import 'package:flutter_blog/domain/post_service.dart';
import 'package:flutter_blog/ui/top_bar.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

class PostDetailPage extends StatefulWidget {
  final int createTime;

  const PostDetailPage({Key? key, required this.createTime}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  /*final TocController _tocController = TocController();*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SelectionArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TopBar(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 1000,
                    child: FutureBuilder(
                      future: getIt.get<PostService>().getPostDetail(widget.createTime),
                      builder: (BuildContext context, AsyncSnapshot<PostDetail> snapshot) {
                        if (snapshot.hasData) {
                          //print(snapshot.data!.content);
                          return _buildMarkdown(snapshot.data!.createTime, snapshot.data!.content);
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildMarkdown(int createTime, String data) {
    return MarkdownBody(
      selectable: true,
      data: data,
      extensionSet: md.ExtensionSet(
        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
      ),
      // styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      //   // codeblockPadding: EdgeInsets.all(100),
      //   // blockquote: const TextStyle(color: Colors.red),
      //   // code: TextStyle(color: Colors.red),
      //   // codeblockDecoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xffF6F8FA)),
      //   // blockquoteDecoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.amber),
      //   // horizontalRuleDecoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue),
      // ),
      styleSheetTheme: MarkdownStyleSheetBaseTheme.cupertino,
      onTapLink: (String text, String? href, String title) {
        if (null != href) {
          launchUrl(Uri.parse(href));
        }
      },
      // imageDirectory: 'images/$createTime/',
      imageBuilder: (Uri uri, String? title, String? alt) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300, maxWidth: 500),
          child: CachedNetworkImage(
            imageUrl: "images/$createTime/${uri.path}",
          ),
        );
      },
    );
  }
}
