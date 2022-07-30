import 'dart:convert';
import 'dart:io';
import 'package:blog/category_item.dart';
import 'package:blog/post_detail.dart';
import 'package:blog/post_item.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

PostItem toPostItem(PostDetail detail) {
  return PostItem(
      title: detail.title,
      createTime: detail.createTime,
      updateTime: detail.updateTime,
      category: detail.category);
}

// posts.json
void createPostsApi(List<PostItem> data) {
  var jsonData = jsonEncode(data);
  File file = File('./../assets/api/posts.json');
  file.writeAsString(jsonData);

  print('create posts.json file :${file.path}, post count: ${data.length}');
}

// categories.json
void createCategoryApi(List<CategoryItem> data) {
  var jsonData = jsonEncode(data);
  File file = File('./../assets/api/categories.json');
  file.writeAsString(jsonData);

  print('create categories.json file :${file.path}, category count: ${data.length}');
}

// title_createTime.json
Future<void> createPostDetail(PostDetail data) async {
  var jsonData = jsonEncode(data);
  File file = File('./../assets/post/${data.createTime}.json');
  file.writeAsString(jsonData);

  print('create post detail json file:${file.path}');
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
      title = element.replaceFirst(RegExp(r'title:'), '').trim();
    } else if (element.startsWith("updated")) {
      updateTime = element.replaceFirst(RegExp(r'updated:'), '').trim();
      updateTime = updateTime.replaceAll(RegExp(r"'"), '').trim();
    } else if (element.startsWith("date")) {
      createTime = element.replaceFirst(RegExp(r'date:'), '').trim();
    } else if (element.startsWith('categories')) {
      category = element.replaceFirst(RegExp(r'categories:'), '').trim();
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
  // 2016-03-07 11:53:45
  var dateFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  return PostDetail(
      title: title,
      createTime: dateFormat.parse(createTime).millisecondsSinceEpoch,
      updateTime: updateTime.isEmpty ? -1 : dateFormat.parse(updateTime).millisecondsSinceEpoch,
      category: category.isEmpty ? "default" : category,
      content: content);
}

void generateBlogData() async {
  try {
    var dir = Directory('./source/post');
    final List<FileSystemEntity> entities = await dir.list().toList();
    List<PostItem> postList = [];
    for (var element in entities) {
      if (element is File && element.path.endsWith('.md')) {
        var postDetail = await parsePostDetailFromMarkdown(element);
        postList.add(toPostItem(postDetail));
        createPostDetail(postDetail);
      } else if (element is Directory) {
        // 目录直接拷贝过去
      }
    }
    // 按时间从大到小排序
    postList.sort((a, b) => b.createTime.compareTo(a.createTime));
    createPostsApi(postList);

    List<CategoryItem> categories = [];
    var categoryMap = groupBy<PostItem, String>(postList, (item) => item.category);
    categoryMap.forEach((key, value) {
      categories.add(CategoryItem(name: key, postCount: value.length));
    });
    createCategoryApi(categories);

  } catch (e ){
    print('generateBlogData error: $e');
  }
}