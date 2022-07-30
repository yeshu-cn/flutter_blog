class PostItem {
  final String title;
  final int createTime;
  final int? updateTime;
  final String? category;

//<editor-fold desc="Data Methods">

  const PostItem({
    required this.title,
    required this.createTime,
    this.updateTime,
    this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostItem &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          createTime == other.createTime &&
          updateTime == other.updateTime &&
          category == other.category);

  @override
  int get hashCode =>
      title.hashCode ^
      createTime.hashCode ^
      updateTime.hashCode ^
      category.hashCode;

  @override
  String toString() {
    return 'PostItem{' +
        ' title: $title,' +
        ' createTime: $createTime,' +
        ' updateTime: $updateTime,' +
        ' category: $category,' +
        '}';
  }

  PostItem copyWith({
    String? title,
    int? createTime,
    int? updateTime,
    String? category,
  }) {
    return PostItem(
      title: title ?? this.title,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'createTime': createTime,
      'updateTime': updateTime,
      'category': category,
    };
  }

  factory PostItem.fromJson(Map<String, dynamic> map) {
    return PostItem(
      title: map['title'] as String,
      createTime: map['createTime'] as int,
      updateTime: map['updateTime'] as int,
      category: map['category'] as String,
    );
  }

//</editor-fold>
}

class PostDetail {
  final String title;
  final int createTime;
  final int? updateTime;
  final String content;

//<editor-fold desc="Data Methods">

  const PostDetail({
    required this.title,
    required this.createTime,
    this.updateTime,
    required this.content,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostDetail &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          createTime == other.createTime &&
          updateTime == other.updateTime &&
          content == other.content);

  @override
  int get hashCode =>
      title.hashCode ^
      createTime.hashCode ^
      updateTime.hashCode ^
      content.hashCode;

  @override
  String toString() {
    return 'PostDetail{' +
        ' title: $title,' +
        ' createTime: $createTime,' +
        ' updateTime: $updateTime,' +
        ' content: $content,' +
        '}';
  }

  PostDetail copyWith({
    String? title,
    int? createTime,
    int? updateTime,
    String? content,
  }) {
    return PostDetail(
      title: title ?? this.title,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'createTime': createTime,
      'updateTime': updateTime,
      'content': content,
    };
  }

  factory PostDetail.fromJson(Map<String, dynamic> map) {
    return PostDetail(
      title: map['title'] as String,
      createTime: map['createTime'] as int,
      updateTime: map['updateTime'] as int,
      content: map['content'] as String,
    );
  }

//</editor-fold>
}

class CategoryItem {
  final String name;
  final int postCount;



  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'postCount': postCount,
    };
  }

  factory CategoryItem.fromJson(Map<String, dynamic> map) {
    return CategoryItem(
      name: map['name'] as String,
      postCount: map['postCount'] as int,
    );
  }

  const CategoryItem({
    required this.name,
    required this.postCount,
  });
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

