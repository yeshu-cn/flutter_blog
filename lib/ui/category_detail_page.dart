import 'package:flutter/material.dart';
import 'package:flutter_blog/di/di.dart';
import 'package:flutter_blog/domain/post_repository.dart';
import 'package:flutter_blog/ui/post_list.dart';
import 'package:flutter_blog/ui/top_bar.dart';

class CategoryDetailPage extends StatefulWidget {
  final String category;

  const CategoryDetailPage({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TopBar(
              highLightCategory: true,
            ),
            PostList(
              loadData: getPostList,
              loadDataCount: getPostCount,
              category: widget.category,
            ),
          ],
        ),
      ),
    );
  }

  Future<List<PostItem>> getPostList(int offset, int limit, String? category) async {
    print('----$category');
    var ret = await getIt.get<PostRepository>().getPostListByCategory(category!, offset, limit);
    return ret;
  }

  Future<int> getPostCount(String? category) async {
    print('----$category');
    return await getIt.get<PostRepository>().getPostCountByCategory(category!);
  }

// Future<List<PostItem>> getPostList(int offset, int limit, String? category) async {
//   return await getIt.get<PostRepository>().getPostListByCategory('category', offset, limit);
// }
//
// Future<int> getPostCount(String? category) async {
//   return await getIt.get<PostRepository>().getPostCountByCategory('category');
// }
}
