import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/loader/simple_overlay_loader.dart';
import '../controller/home_controller.dart';

class PostDetailPage extends StatelessWidget {
  static const String routeName = '/PostDetailPage';
  final int? postId;
  final String? title;
  const PostDetailPage({super.key, this.postId, this.title});

  @override
  Widget build(BuildContext context) {
    final HomeController c = Get.find();
    final arguments = Get.arguments;

    return Scaffold(
      appBar:
          AppBar(title: Text(arguments['title'] ?? '', overflow: TextOverflow.ellipsis)),
      body: SafeArea(
          child: SingleChildScrollView(
        // Since there's only one api call, future builder can handle request
        child: FutureBuilder(
          future: c.getPostDetail(arguments['id']),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const SimpleOverlayLoader();
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final data = snapshot.data;
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(data?.title ?? '',
                              style: const TextStyle(fontSize: 24),
                              textAlign: TextAlign.center),
                        ),
                        Text(data?.body ?? '',
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                  );
                }
            }
          },
        ),
      )),
    );
  }
}
