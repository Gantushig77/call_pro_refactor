import 'package:flutter/foundation.dart';

import '../model/post.dart';
import '../model/req_param.dart';
import 'http_request.dart';

// API helper class, different api's should be divided into their respective classes
class PostApi {
  static Future<List<Post>> getPosts({RequestParam? reqParam}) async {
    final res = await sendRequest('posts', queryParams: reqParam?.toJson());

    debugPrint('PostApi posts : ');
    debugPrint(res.length.toString());

    if (res['result'] != null && res['result'].runtimeType == List) {
      List<Post> resData = res['result'].map<Post>((e) => Post.fromMap(e)).toList();
      return resData;
    }

    return [];
  }

  static Future<Post?> getPost(int id) async {
    final res = await sendRequest('posts/$id');

    debugPrint('PostApi get post : ');
    debugPrint(res.toString());

    if (res['result'] != null) {
      Post resData = Post.fromMap(res['result'] as Map<String, dynamic>);
      return resData;
    }

    return null;
  }
}
