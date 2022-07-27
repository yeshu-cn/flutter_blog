class CategoryItem {
  final String name;
  final int postCount;

  CategoryItem(this.name, this.postCount);
}

class GetCategoriesUseCase {
  Future<List<CategoryItem>> execute() async {
    return [
      CategoryItem('Android', 3),
      CategoryItem('iOS', 4),
      CategoryItem('Flutter', 3),
    ];
  }
}
