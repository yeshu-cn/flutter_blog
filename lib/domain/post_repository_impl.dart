import 'package:flutter_blog/domain/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  var data = List.generate(
      50,
      (index) => PostItem(
          'Post title $index', 1556349134000 + 2626560000 * index, index ~/ 2 == 0 ? 'Android' : 'iOS', 1556349134000));

  @override
  Future<List<PostItem>> getPostList(int offset, int limit) async {
    data.sort((a, b) => b.createTime.compareTo(a.createTime));
    int start = offset;
    int end = offset + limit;
    if (start > data.length - 1) {
      return [];
    }
    if (end > data.length - 1) {
      end = data.length - 1;
    }
    return data.sublist(start, end);
  }

  @override
  Future<PostDetail> getPostDetail(int createTime) async {
    return PostDetail('Flutter 代码生成', 1651043534000, '## Hello world');
  }

  @override
  Future<List<PostItem>> getPostListByCategory(String category, int offset, int limit) async {
    print('------222');
    data.sort((a, b) => b.createTime.compareTo(a.createTime));
    int start = offset;
    int end = offset + limit;
    if (start > data.length - 1) {
      return [];
    }
    if (end > data.length - 1) {
      end = data.length - 1;
    }
    return data.sublist(start, end);
  }

  @override
  Future<int> getPostCountByCategory(String category) async {
    print('------111');
    return data.length;
  }

  @override
  Future<List<PostItem>> getPostListByTag(String tag) async {
    return [];
  }

  @override
  Future<int> getPostCount() async {
    return data.length;
  }

  @override
  Future<List<CategoryItem>> getCategories() async {
    return [];
  }
}
