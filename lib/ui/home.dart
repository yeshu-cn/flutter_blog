import 'package:flutter/material.dart';
import 'package:flutter_blog/di/di.dart';
import 'package:flutter_blog/domain/post_repository.dart';
import 'package:flutter_blog/ui/post_detail_page.dart';
import 'package:flutter_blog/ui/time_line_node.dart';
import 'package:flutter_blog/ui/top_bar.dart';
import 'package:flutter_blog/ui/utils/utils.dart';
import 'package:intl/intl.dart';
import "package:collection/collection.dart";


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TopBar(
              highLightHome: true,
            ),
            FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot<List<PostItem>> snapshot) {
                if (snapshot.hasData) {
                  var postItemWidgets = _buildPostItems(_groupPostItems(snapshot.data!));
                  postItemWidgets.insert(0, _buildPostCountText(snapshot.data!.length));
                  return Padding(
                    padding: const EdgeInsets.only(left: 500, right: 500, top: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: postItemWidgets,
                    ),
                  );
                } else {
                  return const Center(child: Text('Loading...'));
                }
              },
              future: getIt.get<PostRepository>().getPostList(0, 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCountText(int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 7),
      child: Row(
        children: [
          Container(
            height: 10,
            width: 10,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Great! $count posts in total. Keep on posting.',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }

  Widget _buildPostItem(PostItem postItem) {
    var dateFormat = DateFormat('yyyy-MM-dd');
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          navigateTo(
              context,
              PostDetailPage(
                createTime: postItem.createTime,
              ));
        },
        child: TimeLineNode(child: Row(
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
        ),),
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
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

}
