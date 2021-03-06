import 'package:flutter/material.dart';
import 'package:flutter_blog/di/di.dart';
import 'package:flutter_blog/domain/post_service.dart';
import 'package:flutter_blog/ui/top_bar.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PostDetailPage extends StatefulWidget {
  final int createTime;

  const PostDetailPage({Key? key, required this.createTime}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TopBar(),
            Padding(
              padding: const EdgeInsets.only(left: 500, right: 500),
              child: FutureBuilder(
                future: getIt.get<PostService>().getPostDetail(widget.createTime),
                builder: (BuildContext context, AsyncSnapshot<PostDetail> snapshot) {
                  if (snapshot.hasData) {
                    return Markdown(
                      data: snapshot.data!.content,
                      shrinkWrap: true,
                    );
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
      ),
    );
  }
}
