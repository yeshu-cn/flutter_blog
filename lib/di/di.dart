import 'package:flutter_blog/domain/post_service.dart';
import 'package:flutter_blog/domain/post_service_impl.dart';
import 'package:flutter_blog/domain/usecase/get_categories_usecase.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDi() {
  getIt.registerFactory<PostService>(() => PostServiceImpl());

  getIt.registerFactory<GetCategoriesUseCase>(() => GetCategoriesUseCase());
}