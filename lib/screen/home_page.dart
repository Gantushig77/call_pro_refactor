import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/loader/simple_overlay_loader.dart';
import '../component/post/post_item.dart';
import '../controller/home_controller.dart';

class MyHomePage extends StatelessWidget {
  static const String routeName = '/home';

  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Registering the controller for home page
    HomeController c = Get.put(HomeController());

    // Checking if it's tablet size or not. Depending on the size of the device,
    // conditional render can be used to render appropriate size widgets.
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Refactor Task App'),
        actions: [
          Obx(
            () => IconButton(
                onPressed: () => c.setDarkMode(),
                icon: Icon(c.isDark.value ? Icons.sunny : Icons.dark_mode)),
          ),
          Obx(
            () => IconButton(
                onPressed: () => c.setGridView(!c.grid.value),
                icon: Icon(c.grid.value ? Icons.grid_view_outlined : Icons.list)),
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: Get.height,
              width: Get.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Since OBX works only one widget, using get builder
                    GetBuilder<HomeController>(
                      builder: (hc) => hc.grid.value
                          ? GridView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent:
                                      useMobileLayout ? Get.width / 2 : Get.width / 4,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  mainAxisExtent: useMobileLayout
                                      ? Get.height / 2.5
                                      : Get.height / 3),
                              itemCount: hc.posts.length,
                              itemBuilder: (context, index) {
                                return PostItem(
                                    grid: true, index: index, post: hc.posts[index]);
                              })
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: hc.posts.length,
                              itemBuilder: (context, index) {
                                return PostItem(index: index, post: hc.posts[index]);
                              }),
                    ),
                  ],
                ),
              ),
            ),
            // Rendering loading icon, can be improved with getx overlays
            Obx(() => c.loading.value ? const SimpleOverlayLoader() : const SizedBox())
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => c.getPosts(local: false),
        tooltip: 'Fetch Data',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
