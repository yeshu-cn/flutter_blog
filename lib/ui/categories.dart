import 'package:flutter/material.dart';
import 'package:flutter_blog/di/di.dart';
import 'package:flutter_blog/domain/usecase/get_categories_usecase.dart';
import 'package:flutter_blog/ui/category_detail_page.dart';
import 'package:flutter_blog/ui/top_bar.dart';
import 'package:flutter_blog/ui/utils/utils.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopBar(highLightCategory: true,),
            Padding(
              padding: const EdgeInsets.only(left: 500, right: 500, top: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Categories', style: theme.textTheme.headline6,),
                ],
              ),
            ),
            FutureBuilder(builder: (BuildContext context, AsyncSnapshot<List<CategoryItem>> snapshot){
              if (snapshot.hasData) {
                var categoryItems = snapshot.data!.map((e) => _buildItem(e)).toList();
                categoryItems.insert(0, _buildCategoryCountText(snapshot.data!.length));
                return Padding(
                  padding: const EdgeInsets.only(left: 500, right: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: categoryItems,
                  ),
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

  Widget _buildCategoryCountText(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 40, top: 60),
          child: Text('$count categories in total', style: Theme.of(context).textTheme.subtitle1),
        ),
      ],
    );
  }

  Widget _buildItem(CategoryItem item) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: (){
        navigateTo(context, CategoryDetailPage(category: item.name,));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Text(item.name, style: theme.textTheme.subtitle1,),
            ),
            Text('[${item.postCount}]', style: theme.textTheme.subtitle1!.copyWith(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
