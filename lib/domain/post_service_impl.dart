import 'dart:convert';
import 'package:flutter_blog/domain/post_service.dart';
import 'package:flutter/services.dart';

class PostServiceImpl implements PostService {
  @override
  Future<PostListResponse> getPostList(int offset, int limit) async {
    var data = await rootBundle.loadString("assets/api/posts.json");
    var jsonData = jsonDecode(data);
    var postList =
        List<PostItem>.from(jsonData.map((x) => PostItem.fromJson(x)));

    postList.sort((a, b) => b.createTime.compareTo(a.createTime));
    int start = offset;
    int end = offset + limit;
    if (start > postList.length - 1) {
      return PostListResponse(totalCount: postList.length, data: []);
    }
    if (end > postList.length) {
      end = postList.length;
    }
    return PostListResponse(
        data: postList.sublist(start, end), totalCount: postList.length);
  }

  @override
  Future<PostDetail> getPostDetail(int createTime) async {
    var data = await rootBundle.loadString("assets/post/$createTime.json");
    return PostDetail.fromJson(jsonDecode(data));
  }

  @override
  Future<PostListResponse> getPostListByCategory(
      String category, int offset, int limit) async {
    var data = await rootBundle.loadString("assets/api/posts.json");
    var jsonData = jsonDecode(data);
    var postList =
        List<PostItem>.from(jsonData.map((x) => PostItem.fromJson(x)))
            .where((element) => element.category == category)
            .toList();

    postList.sort((a, b) => b.createTime.compareTo(a.createTime));
    int start = offset;
    int end = offset + limit;
    if (start > postList.length - 1) {
      return PostListResponse(totalCount: postList.length, data: []);
    }
    if (end > postList.length) {
      end = postList.length;
    }
    return PostListResponse(
        data: postList.sublist(start, end), totalCount: postList.length);
  }

  @override
  Future<List<PostItem>> getPostListByTag(String tag) async {
    return [];
  }

  @override
  Future<List<CategoryItem>> getCategories() async {
    var data = await rootBundle.loadString("assets/api/categories.json");
    var jsonData = jsonDecode(data);
    return List<CategoryItem>.from(
        jsonData.map((x) => CategoryItem.fromJson(x)));
  }
}
