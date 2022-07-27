import 'package:flutter_blog/domain/post_repository.dart';
import 'package:flutter_blog/domain/post_repository_impl.dart';
import 'package:flutter_blog/domain/usecase/get_categories_usecase.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDi() {
  getIt.registerFactory<PostRepository>(() => PostRepositoryImpl());

  getIt.registerFactory<GetCategoriesUseCase>(() => GetCategoriesUseCase());
}