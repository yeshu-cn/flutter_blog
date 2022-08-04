import 'package:blog/blog.dart';

void main(List<String> arguments) async {
  generateBlogData(postSourcePath: arguments[0], assetsPath: arguments[1], webPath: arguments[2]);
  // testReadFile();
}
