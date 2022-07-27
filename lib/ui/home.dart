import 'package:flutter/material.dart';
import 'package:flutter_blog/di/di.dart';
import 'package:flutter_blog/domain/post_repository.dart';
import 'package:flutter_blog/ui/post_detail_page.dart';
import 'package:flutter_blog/ui/top_bar.dart';
import 'package:flutter_blog/ui/utils/utils.dart';
import 'package:intl/intl.dart';

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
            const TopBar(),
            FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot<List<PostItem>> snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(80.0),
                    child: Column(
                      children: snapshot.data!.map((e) => _buildPostItem(e)).toList(),
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
        child: Row(
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
}
