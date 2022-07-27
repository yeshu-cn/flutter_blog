class PostItem {
  final String title;
  final int createTime;
  final int? updateTime;

  PostItem(this.title, this.createTime, [this.updateTime]);
}

class PostDetail {
  final String title;
  final int createTime;
  final int? updateTime;
  final String content;

  PostDetail(this.title, this.createTime, this.content, [this.updateTime]);
}

abstract class PostRepository {
  Future<List<PostItem>> getPostList(int offset, int limit);

  Future<PostDetail> getPostDetail(int createTime);

  Future<List<PostItem>> getPostListByTag(String tag);

  Future<List<PostItem>> getPostListByCategory(String category);
}

