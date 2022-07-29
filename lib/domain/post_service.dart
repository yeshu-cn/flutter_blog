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

class PostListResponse {
  final List<PostItem> data;
  final int totalCount;

  const PostListResponse({
    required this.data,
    required this.totalCount,
  });
}

abstract class PostService {
  Future<PostListResponse> getPostList(int offset, int limit);

  Future<PostDetail> getPostDetail(int createTime);

  Future<List<PostItem>> getPostListByTag(String tag);

  Future<PostListResponse> getPostListByCategory(String category, int offset, int limit);

  Future<List<CategoryItem>> getCategories();
}

