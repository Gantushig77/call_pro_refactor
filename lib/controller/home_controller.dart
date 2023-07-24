import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../api/post_api.dart';
import '../constant/config.dart';
import '../model/post.dart';
import '../model/req_param.dart';

class HomeController extends GetxController {
  final box = Hive.box(hiveBoxName);

  List<Post> posts = [];
  Post? currentPost;

  RxBool loading = false.obs;
  RxBool grid = false.obs;
  RxBool isDark = false.obs;

  @override
  void onInit() {
    super.onInit();
    // On initialization, ready posts from local storage :
    getPosts(local: true);
  }

  // get posts:
  Future<List<Post>> getPosts(
      {bool local = true,
      RequestParam? reqParam,
      bool saveLocal = true,
      bool add = true,
      bool firstLoad = true}) async {
    if (local) {
      loading.value = true;
      List<Post> old = (box.get('posts') ?? []).map<Post>((e) => e as Post).toList();
      posts = old;
      loading.value = false;
      return old;
    } else {
      List<Post> newPosts =
          await getNetworkPosts(saveLocal: saveLocal, add: add, firstLoad: firstLoad);
      return newPosts;
    }
  }

  Future<List<Post>> getNetworkPosts(
      {RequestParam? reqParam,
      bool saveLocal = true,
      bool add = true,
      bool firstLoad = true}) async {
    loading.value = true;

    final res = await PostApi.getPosts(reqParam: reqParam);

    // if there's pagination, adding to the current data will be useful
    if (add) {
      if (firstLoad) posts = res;
      if (!firstLoad) posts.addAll(res);
    }

    // saving to local storage with the help of hive adapter
    if (saveLocal) {
      await box.delete('posts');
      await box.put('posts', res);
    }

    loading.value = false;
    return [];
  }

  Future<Post?> getPostDetail(int? id) async {
    if (id != null) {
      final res = await PostApi.getPost(id);
      currentPost = res;
      loading.value = false;
      return res;
    }
    return null;
  }

  setDarkMode() async {
    if (Get.isDarkMode) {
      Get.changeThemeMode(ThemeMode.light);
      isDark.value = false;
      await box.put('isDark', false);
    } else {
      Get.changeThemeMode(ThemeMode.dark);
      isDark.value = true;
      await box.put('isDark', true);
    }
  }

  setGridView(bool val) {
    grid.value = val;
    update();
  }
}
