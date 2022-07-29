import 'dart:convert';
import 'dart:io';

import 'package:blog/blog.dart' as blog;

class PostItem {
  final String title;
  final int createTime;
  final int updateTime;
  final String category;

  const PostItem({
    required this.title,
    required this.createTime,
    required this.updateTime,
    required this.category,
  });
}

class PostDetail {
  final String title;
  final int createTime;
  final int updateTime;
  final String category;
  final String content;

  const PostDetail({
    required this.title,
    required this.createTime,
    required this.updateTime,
    required this.category,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'createTime': createTime,
      'updateTime': updateTime,
      'category': category,
      'content': content,
    };
  }

  factory PostDetail.fromJson(Map<String, dynamic> map) {
    return PostDetail(
      title: map['title'] as String,
      createTime: map['createTime'] as int,
      updateTime: map['updateTime'] as int,
      category: map['category'] as String,
      content: map['content'] as String,
    );
  }
}

class PostListResponse {
  final int totalCount;
  final List<PostItem> data;

  PostListResponse(this.totalCount, this.data);
}

class CategoryItem {
  final String name;
  final int postCount;

  CategoryItem(this.name, this.postCount);
}

// posts.json
void createPostsApi(List<PostItem> data) {

}

// categories.json
void createCategoryApi(List<CategoryItem> data) {

}

// title_createTime.json
Future<void> createPostDetail(PostDetail data) async {
  var jsonData = jsonEncode(data);
  File file = File('${data.title}_${data.createTime}.json');
  file.writeAsString(jsonData);
}

Future<PostDetail> parsePostDetailFromMarkdown(FileSystemEntity entity) async {
  var lines = await (entity as File).readAsLines();
  lines.removeAt(0);
  String title = '';
  String createTime = '';
  String updateTime = '';
  String category = '';
  String content = '';
  int i = 0;
  for (var element in lines) {
    if (element.startsWith("title")) {
      title = element.split(':')[1].trim();
    } else if (element.startsWith("updated")) {
      updateTime = element.split(':')[1].trim();
    } else if (element.startsWith("date")) {
      createTime = element.split(':')[1].trim();
    } else if (element.startsWith('category')) {
      category = element.split(':')[1].trim();
    } else if (element.startsWith('---')) {
      i++;
      break;
    }
    i++;
  }
  lines.removeRange(0, i);
  for (var element in lines) {
    content = '$content \n $element';
  }
  return PostDetail(title: title, createTime: 0, updateTime: 0, category: category, content: content);

}

void main(List<String> arguments) async {
  print('Hello world: ${blog.calculate()}!');
  var dir = Directory('./source/post');
  final List<FileSystemEntity> entities = await dir.list().toList();
  entities.forEach((element) async {
    var postDetail = await parsePostDetailFromMarkdown(element);
    createPostDetail(postDetail);
  });

}

