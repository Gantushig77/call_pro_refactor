import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/post.dart';
import '../../screen/post_detail.dart';

class PostItem extends StatelessWidget {
  final Post? post;
  final int? index;
  final bool? grid;
  const PostItem({super.key, this.post, this.index, this.grid});

  @override
  Widget build(BuildContext context) {
    if (grid == true) {
      return Material(
        elevation: 2,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: InkWell(
          onTap: () => Get.toNamed(PostDetailPage.routeName,
              arguments: {"id": post?.id, "title": post?.title}),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Text(
                  '${post?.id}. ${post?.title}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  post?.body ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 6,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ExpansionTile(
        title: InkWell(
          onTap: () => Get.toNamed(PostDetailPage.routeName,
              arguments: {"id": post?.id, "title": post?.title}),
          child: Text(
            '${post?.id}. ${post?.title}',
            style: const TextStyle(fontSize: 18),
          ),
        ),
        children: [
          Container(
            width: Get.width,
            padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10, right: 20),
            child: Text(
              post?.body ?? '',
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ]);
  }
}
