import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blog/di/di.dart';
import 'package:flutter_blog/domain/post_service.dart';
import 'package:flutter_blog/ui/toc_item.dart';
import 'package:flutter_blog/ui/top_bar.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_widget/config/widget_config.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetailPage extends StatefulWidget {
  final int createTime;

  const PostDetailPage({Key? key, required this.createTime}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final TocController _tocController = TocController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
    );
  }

  Widget _buildTocWidget() {
    return TocListWidget(
      controller: _tocController,
      tocItem: (toc, isCurrent) {
        return TocItemWidget(
          isCurrent: isCurrent,
          toc: toc,
          onTap: () {
            _tocController.jumpTo(index: toc.index);
          },
        );
      },
    );
  }

  Widget _buildMarkdown(int createTime, String data) {
    return Markdown(
      data: data,
      shrinkWrap: true,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        // blockquote: const TextStyle(color: Colors.red),
        // codeblockDecoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green),
        // blockquoteDecoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.amber),
        // horizontalRuleDecoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue),
      ),
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
    // return MarkdownWidget(
    //   data: data,
    //   // childMargin: const EdgeInsets.only(top: 20),
    //   shrinkWrap: true,
    //   widgetConfig: WidgetConfig(
    //     p: (node) {
    //       print('--->');
    //       print(node.textContent);
    //       return PWidget(parentNode: node, children: node.children,);
    //       // return Text(node.textContent);
    //     },
    //     pre: (node) {
    //       // print(node);
    //       return PreWidget(node: node);
    //     },
    //   ),
    //   styleConfig: StyleConfig(
    //     markdownTheme: MarkdownTheme.lightTheme,
    //     imgBuilder: (String url, Map<String, String> attributes) {
    //       // 构造图片地址并显示,点击显示图片原本大小
    //       return ConstrainedBox(
    //         constraints: const BoxConstraints(maxHeight: 300, maxWidth: 500),
    //         child: CachedNetworkImage(
    //           imageUrl: "images/$createTime/$url",
    //         ),
    //       );
    //     },
    //     pConfig: PConfig(
    //       textStyle: const TextStyle(height: 1.5),
    //       onLinkTap: (url) {
    //         if (null != url) {
    //           launchUrl(Uri.parse(url));
    //         }
    //       },
    //     ),
    //     preConfig: PreConfig(
    //       preWrapper: (child, text) {
    //         return Stack(
    //           children: <Widget>[
    //             child,
    //             Container(
    //               margin: const EdgeInsets.only(top: 5, right: 5),
    //               alignment: Alignment.topRight,
    //               child: IconButton(
    //                 onPressed: () {
    //                   Clipboard.setData(ClipboardData(text: text));
    //                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('复制成功')));
    //                 },
    //                 icon: const Icon(
    //                   Icons.content_copy,
    //                   size: 10,
    //                 ),
    //               ),
    //             )
    //           ],
    //         );
    //       },
    //       language: 'java',
    //     ),
    //     ulConfig: UlConfig(dotMargin: const EdgeInsets.all(10), crossAxisAlignment: CrossAxisAlignment.center),
    //     olConfig: OlConfig(
    //         olWrapper: ((Widget child) {
    //           return Padding(
    //             padding: const EdgeInsets.only(top: 4, bottom: 4),
    //             child: child,
    //           );
    //         }),
    //         crossAxisAlignment: CrossAxisAlignment.center),
    //     codeConfig: CodeConfig(
    //       codeStyle: TextStyle(color: Colors.green[700]),
    //     ),
    //     blockQuoteConfig: BlockQuoteConfig(
    //       textConfig: TextConfig(),
    //       blockStyle: const TextStyle(height: 1.5),
    //     ),
    //     titleConfig: TitleConfig(
    //       showDivider: true,
    //     ),
    //   ),
    // );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
