import 'package:blog/post_item.dart';

class PostListResponse {
  final int totalCount;
  final List<PostItem> data;

  PostListResponse(this.totalCount, this.data);
}