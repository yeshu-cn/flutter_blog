import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/domain/post_service.dart';
import 'package:flutter_blog/ui/paginator.dart';
import 'package:flutter_blog/ui/post_detail_page.dart';
import 'package:flutter_blog/ui/time_line_node.dart';
import 'package:flutter_blog/ui/utils/utils.dart';
import 'package:intl/intl.dart';

class PostList extends StatefulWidget {
  final Future<PostListResponse> Function(int offset, int limit, String? category) loadData;
  final String? category;

  const PostList({Key? key, required this.loadData, this.category}) : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  int _currentPage = 0;
  final int _pageSize = 10;
  int _totalPostCount = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<PostListResponse> snapshot) {
        if (snapshot.hasData) {
          _totalPostCount = snapshot.data!.totalCount;
          var pageCount = (_totalPostCount + _pageSize - 1) ~/ _pageSize;

          var postItemWidgets = _buildPostItems(_groupPostItems(snapshot.data!.data));
          postItemWidgets.insert(
              0, widget.category == null ? _buildPostCountText(_totalPostCount) : _buildCategoryTitle());
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 500, right: 500, top: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: postItemWidgets,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 480, right: 480),
                child: Divider(),
              ),
              if (pageCount > 1)
                Padding(
                  padding: const EdgeInsets.only(left: 480),
                  child: SizedBox(
                      width: 300,
                      child: NumberPaginator(
                        onPageChange: (index) {
                          _currentPage = index;
                          setState(() {});
                        },
                        numberPages: pageCount.toInt(),
                        buttonUnselectedBackgroundColor: Colors.transparent,
                        buttonUnselectedForegroundColor: Colors.black54,
                        buttonSelectedBackgroundColor: Colors.transparent,
                        buttonSelectedForegroundColor: Colors.black,
                      )),
                ),
              const SizedBox(
                height: 80,
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      future: widget.loadData(_currentPage * _pageSize, _pageSize, widget.category),
    );
  }

  Widget _buildPostCountText(int count) {
    return TimeLineNode(
        firstNode: true,
        child: Text(
          'Great! $count posts in total. Keep on posting.',
          style: Theme.of(context).textTheme.subtitle1,
        ));
  }

  Widget _buildCategoryTitle() {
    return TimeLineNode(
        firstNode: true,
        child: Row(
          children: [
            Text(
              widget.category!,
              style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              'Category',
              style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  Widget _buildPostItem(PostItem postItem) {
    var dateFormat = DateFormat('yyyy-MM-dd');
    var theme = Theme.of(context);
    return TimeLineNode(
      child: InkWell(
        onTap: () {
          navigateTo(
              context,
              PostDetailPage(
                createTime: postItem.createTime,
              ));
        },
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Text(
              dateFormat.format(DateTime.fromMillisecondsSinceEpoch(postItem.createTime)),
              style: theme.textTheme.subtitle1,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(postItem.title, style: theme.textTheme.subtitle1),
          ],
        ),
      ),
    );
  }

  Map<String, List<PostItem>> _groupPostItems(List<PostItem> list) {
    var dateFormat = DateFormat('yyyy');
    var groupByDate = groupBy<PostItem, String>(
        list, (item) => dateFormat.format(DateTime.fromMillisecondsSinceEpoch(item.createTime)));
    return groupByDate;
  }

  List<Widget> _buildPostItems(Map<String, List<PostItem>> data) {
    var widgetList = <Widget>[];
    data.forEach((key, value) {
      widgetList.add(_buildYearGroupTitle(key));
      widgetList.addAll(value.map((e) => _buildPostItem(e)).toList());
    });
    return widgetList;
  }

  Widget _buildYearGroupTitle(String title) {
    return TimeLineNode(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
