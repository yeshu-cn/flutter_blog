import 'package:flutter/material.dart';
import 'package:flutter_blog/di/di.dart';
import 'package:flutter_blog/domain/post_service.dart';
import 'package:flutter_blog/ui/post_list.dart';
import 'package:flutter_blog/ui/top_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopBar(
              highLightHome: true,
            ),
            PostList(
              loadData: getPostList,
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }

  Future<PostListResponse> getPostList(int offset, int limit, String? category) async {
    return await getIt.get<PostService>().getPostList(offset, limit);
  }
}
