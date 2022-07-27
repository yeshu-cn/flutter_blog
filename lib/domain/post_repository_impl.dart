import 'package:flutter_blog/domain/post_repository.dart';

class PostRepositoryImpl implements PostRepository {

  @override
  Future<List<PostItem>> getPostList(int offset, int limit) async {
    return [
      PostItem('Flutter 代码生成', 1658905934000),
      PostItem('移动端App架构Demo mock_app', 1656313934000),
      PostItem('《整洁架构之道》笔记', 1653635534000),
      PostItem('日志使用总结', 1651043534000),
      PostItem('分层架构的演进', 1619507534000),
      PostItem('防御使编程和契约式编程', 1587971534000),
      PostItem('Repository设计', 1587971534000),
      PostItem(' Android混淆和反编译结果查看', 1556349134000),
    ];
  }

  @override
  Future<PostDetail> getPostDetail(int createTime) async {
    return PostDetail('Flutter 代码生成', 1651043534000, '## Hello world');
  }

  @override
  Future<List<PostItem>> getPostListByCategory(String category) {
    // TODO: implement getPostListByCategory
    throw UnimplementedError();
  }

  @override
  Future<List<PostItem>> getPostListByTag(String tag) {
    // TODO: implement getPostListByTag
    throw UnimplementedError();
  }
}