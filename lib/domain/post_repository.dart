import 'package:flutter_blog/domain/usecase/get_categories_usecase.dart';

class PostItem {
  final String title;
  final int createTime;
  final int? updateTime;
  final String? category;

  PostItem(this.title, this.createTime, this.category, this.updateTime);
}

class PostDetail {
  final String title;
  final int createTime;
  final int? updateTime;
  final String content;

  PostDetail(this.title, this.createTime, this.content, [this.updateTime]);
}

class CategoryItem {
  final String name;
  final int postCount;

  CategoryItem(this.name, this.postCount);
}

abstract class PostRepository {
  Future<List<PostItem>> getPostList(int offset, int limit);

  Future<int> getPostCount();

  Future<PostDetail> getPostDetail(int createTime);

  Future<List<PostItem>> getPostListByTag(String tag);

  Future<List<PostItem>> getPostListByCategory(String category, int offset, int limit);

  Future<int> getPostCountByCategory(String category);

  Future<List<CategoryItem>> getCategories();
}

