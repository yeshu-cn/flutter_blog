import 'package:flutter_blog/domain/post_service.dart';

class PostServiceImpl implements PostService {
  var data = List.generate(
      50,
      (index) => PostItem(
          'Post title $index', 1556349134000 + 2626560000 * index, index ~/ 2 == 0 ? 'Android' : 'iOS', 1556349134000));

  @override
  Future<PostListResponse> getPostList(int offset, int limit) async {
    data.sort((a, b) => b.createTime.compareTo(a.createTime));
    int start = offset;
    int end = offset + limit;
    if (start > data.length - 1) {
      return PostListResponse(totalCount: data.length, data: []);
    }
    if (end > data.length - 1) {
      end = data.length - 1;
    }
    return PostListResponse(data: data.sublist(start, end), totalCount: data.length);
  }

  @override
  Future<PostDetail> getPostDetail(int createTime) async {
    return PostDetail('Flutter 代码生成', 1651043534000, '## Hello world');
  }

  @override
  Future<PostListResponse> getPostListByCategory(String category, int offset, int limit) async {
    data.sort((a, b) => b.createTime.compareTo(a.createTime));
    int start = offset;
    int end = offset + limit;
    if (start > data.length - 1) {
      return PostListResponse(totalCount: data.length, data: []);
    }
    if (end > data.length - 1) {
      end = data.length - 1;
    }
    return PostListResponse(data: data.sublist(start, end), totalCount: data.length);
  }

  @override
  Future<List<PostItem>> getPostListByTag(String tag) async {
    return [];
  }

  @override
  Future<List<CategoryItem>> getCategories() async {
    return [
      CategoryItem('Android', 3),
      CategoryItem('iOS', 4),
      CategoryItem('Flutter', 3),
    ];
  }
}
