import 'package:get/get_connect/connect.dart';

import '../model/post.dart';

// Can be used instead of initiating a custom dio class
class UserProvider extends GetConnect {
  Future<List<Post>> getPosts() async {
    Response res = await get('$baseUrl/posts');

    if (res.body.runtimeType == List) {
      final data = res.body.map<Post>((e) => Post.fromJson(e)).toList();
      return data;
    }
    return [];
  }
}
