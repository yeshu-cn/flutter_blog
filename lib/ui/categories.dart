import 'package:flutter/material.dart';
import 'package:flutter_blog/di/di.dart';
import 'package:flutter_blog/domain/usecase/get_categories_usecase.dart';
import 'package:flutter_blog/ui/top_bar.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TopBar(),
            const Text('categories'),
            FutureBuilder(builder: (BuildContext context, AsyncSnapshot<List<CategoryItem>> snapshot){
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data!.map((e) => _buildItem(e)).toList(),
                );
              } else {
                return const CircularProgressIndicator();
              }
            }, future: getIt.get<GetCategoriesUseCase>().execute(),),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(CategoryItem item) {
    return Row(
      children: [
        Text(item.name),
        Text('[${item.postCount}]'),
      ],
    );
  }
}
